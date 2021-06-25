These are systematic generator matrices for the AR4JA code.
They include the pucture symbols (i.e. variable) in the far-right columns.
They were created according to the method in the CCSDS spec,
except for the largest block lengths.  My computer ran out of memory
for those.  Here is the creation process explained in email...

Daniel,

I first work on the polynomials.  All math on the polynomials modulo x^m+1
is pretty straight forward except division.  There is a standard convention for
storing polynomials in Matlab as a vector of ordered coefficients:
such as:  xpoly=[a b c] for p(x)=a x^2 + b x + c.  However, some of the code
that I wrote uses a different convention knowing that the coefficients are binary.
I store xpoly=[ a b c ]  for p(x) = x^a + x^b + x^c in the code below.

1.  Form P & Q as matrices of polynomials.  In MATLAB I just store the exponent
of each entry and use -1 to indicate nothing, as zero is used for x^0.

        [J L]=size(Hpoly);
        P = Hpoly(:,L-J+1:L); % one term max per matrix entry allowed
        Q = Hpoly(:,1:L-J);   % one term max per matrix entry allowed


2.  I have a routine that takes the permanent of a matrix of polynomials that I wrote
for a paper a couple years ago and permanent(A) = determinant(A) in this ring of
polynomials.  So I compute z=perm(A), which is a polynomial with many terms.

        per=polyperm(P);  % compute permanent
        per=sort(mod(per,pmax)); % organize
        per=polychar2(per);  % reduce

pmax is 32 for rate=4/5, k=1024 for example

3.  I then use Euclids algorithm to invert this.  That was a pain.  So now I have 1/z.
(By the way, any polynomial is not necessarily invertible in this ring.  The
routine that does this tests the result to see if the polymial times its inverse is one)
           detinv=polyinvc2(per,xmplusone);


4.  I then compute the cofactor of each entry of P in polynomial form and immediately 
turn it to binary

        Pinv=zeros(J*pmax,J*pmax);
        for i=1:J,
            for j=1:J,
                minor = P([1:(i-1) (i+1):J],[1:(j-1) (j+1):J]);
                per=polyperm(minor);  % compute permanent
                per=sort(mod(per,pmax)); % organize
                per=polychar2(per);  % reduce
                prod=[];
                for m=1:length(per),
                    prod=[prod per(m)+detinv];  % multiply
                end
                prod=sort(mod(prod,pmax)); % organize
                prod=polychar2(prod);  % reduce
                
                Pinvsub=zeros(pmax,pmax);
                for m=1:length(prod),
                    for row=1:pmax,    % turn to binary
                        Pinvsub(row,1+mod(prod(m)+row-1,pmax))=1;
                    end %end for row
                end %end for m
                Pinv(1+(i-1)*pmax:i*pmax,1+(j-1)*pmax:j*pmax)=Pinvsub';
                        % note the extra transpose above! 
            end %end for j
        end %end for i

5.  A final transpose complete the inversion of P
        Pinv=Pinv';  % transpose for inversion

6.  Convert Q to binary 
        % need to convert Q to binary
        Qbin=sparse(zeros(J*pmax,(J-L)*pmax));
        for i=1:J,
            for j=1:L-J,
                if Q(i,j)<0,
                    continue;
                end
                Qsub=zeros(pmax,pmax);
                for row=1:pmax,
                    Qsub(row,1+mod(Q(i,j)+row-1,pmax))=1;
                end %end for row
                Qbin(1+(i-1)*pmax:i*pmax,1+(j-1)*pmax:j*pmax)=Qsub;                
            end %end for j
        end %end for i 

7.  Form G (generator matrix)
        W=(Pinv*Qbin)';
        W=mod(W,2);
        G=[eye((L-J)*pmax) W];

8. Validate against binary H matrix
        synd=mod(H*G',2);
        if all(all(synd==0)),
            fprintf('Success making generator for AR4JA %d %d!\n',ri,ki);
        else
            fprintf('Failure making generator for AR4JA %d %d!\n',ri,ki);
        end

-Brian
