# Doily incidence matrix GQ(2,2)
LoadPackage("fining");
q:=2;
ps := PG(2,2);
lines := Lines(ps);
points := Points(ps);
incidences := [];
for line in lines do
    row := [];
    incident_to_line := Set(ShadowOfElement(ps,line,1));
    for point in points do
        if point in incident_to_line then
            Add(row,1);
        else
            Add(row,0);
        fi;
    od;
    Add(incidences,row);
od;
# Output incidence matrix in Matlab-ready format
output := OutputTextFile("Doily.txt", false );
SetPrintFormattingStatus(output, false);
PrintTo(output,"");
for row in incidences do
    for cell in row do
        AppendTo(output,cell);
        AppendTo(output," ");
    od;
    AppendTo(output,"\n");
od;
