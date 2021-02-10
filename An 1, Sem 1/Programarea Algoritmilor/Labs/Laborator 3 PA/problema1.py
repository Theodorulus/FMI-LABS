parole = ["Wadf2133", "Qsdd2111", "Bbyt7690", "Qzol4573", "Piur9463", "Manu4455", "Theo9067", "Cakp7309", "Fgql8239", "Opqz8520", "Algr5390", "Xexc8649"]
fin = open ("date.in")
fout = open ("date.out", "w")
i = 0
nume = fin.readline()
while nume != "":
    p = nume.split()
    mail = p[1].lower() + "." + p[0].lower() + "@myfmi.unibuc.ro"
    fout.write (mail + ",")
    fout.write (parole [i % 12] + "\n")
    i += 1
    nume = fin.readline()
fin.close()
fout.close()