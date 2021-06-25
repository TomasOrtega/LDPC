LoadPackage("fining");
# Choose the GQ
# Reasonable bounds are: Q-(5,q), q <= 3
#                       H(4,q^2), q <= 3

q := 11;
GQ := HyperbolicQuadric(3,q);
# GQ := ParabolicQuadric(4,q);
# GQ := EllipticQuadric(5,q);
# GQ := HermitianPolarSpace(4,q*q);

lines_GQ := Lines(GQ);
points_GQ := Points(GQ);
incidences := [];
for line in lines_GQ do
    row := [];
    incident_to_line := Set(ShadowOfElement(GQ, line, 1));
    for point in points_GQ do
        if point in incident_to_line then
            Add(row, 1);
        else
            Add(row, 0);
        fi;
    od;
    Add(incidences,row);
od;

# Output incidence matrix in Matlab-ready format
output := OutputTextFile("out.txt", false);
SetPrintFormattingStatus(output, false);
PrintTo(output, "");
for row in incidences do
    for cell in row do
        AppendTo(output, cell);
        AppendTo(output, " ");
    od;
    AppendTo(output, "\n");
od;
