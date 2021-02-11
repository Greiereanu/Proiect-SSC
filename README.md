# Proiect-SSC
Proiect Structura Sistemelor de Calcul - conexiunea dintre placa FPGA si PC utilizand UART


Proiect realizat in VHDL, are la baza comunicarea UART dintre placa de dezvoltare si PC. Proiectul este pus in functiune, pe langa partea de VHDL, de un fisier Python,
care are la baza o interfata. Aceasta controleaza un cronometru de pe placa FPGA(Cele 3 butoane de Start, Stop, Reset), dar are si un buton de Receive, care citeste informatia
de pe 8 switchuri de pe placa de dezvoltare, si il afiseaza sub forma de cod ASCII
