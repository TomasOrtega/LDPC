LoadPackage("fining");
# Choose the GQ
# Reasonable bounds are: Q-(5,q) for q <= 3
#                       H(4,q^2) for q <= 3
q:=3;
# GQ := HyperbolicQuadric(3,q);
# GQ := ParabolicQuadric(4,q);
GQ := EllipticQuadric(5,q);
# GQ := HermitianPolarSpace(4,q*q);
lines_GQ := Lines(GQ);
points_GQ := Points(GQ);
incidences := [];
for line in lines_GQ do
    row := [];
    incident_to_line := Set(ShadowOfElement(GQ,line,1));
    for point in points_GQ do
        if point in incident_to_line then
            Add(row,1);
        else
            Add(row,0);
        fi;
    od;
    Add(incidences,row);
od;
H := incidences * Z(2)^0;
# If we are in Q(3,q) we have to transpose H
# H := TransposedMat(H);
G := NullspaceMat(H);
# Output matrix in Matlab-ready format
output := OutputTextFile("out.txt", false );
SetPrintFormattingStatus(output, false);
PrintTo(output,"");
for row in G do
    for cell in row do
    	if cell = Z(2)^0 then
    	    AppendTo(output,1);
    	else 
    	    AppendTo(output,0);
    	fi;
        AppendTo(output," ");
    od;
    AppendTo(output,"\n");
od;
