BEGIN {tggui[5000];tgnhan[5000];tgtruyen[5000];sogoi=0;}
{
if (($1 == "s") && ($3 == "_4_")&&($4=="AGT"))
{
tggui[$18] = $2;
}
if (($1 == "r") && ($3 == "_35_")&&($4=="AGT"))
{
tgnhan[$18] = $2;
tgtruyen[$18] = tgnhan[$18]-tggui[$18];
print $18" "tgtruyen[$18]  >>"delay.tr"
}

}
END {}


