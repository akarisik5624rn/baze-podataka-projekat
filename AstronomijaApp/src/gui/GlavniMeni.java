package gui;

import javax.swing.*;
import java.awt.*;

public class GlavniMeni extends JFrame {

    private int idKorisnika;
    private String korisnickoIme;

    public GlavniMeni(int idKorisnika, String korisnickoIme) {
        this.idKorisnika = idKorisnika;
        this.korisnickoIme = korisnickoIme;

        setTitle("Glavni meni - " + korisnickoIme);
        setSize(400, 300);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLocationRelativeTo(null);
        setLayout(new GridLayout(4, 1, 10, 10));

        JButton laboratorijeBtn = new JButton("Pregled laboratorija i istrazivaca");
        JButton azuriranjeBtn = new JButton("Azuriranje korisnickog imena i lozinke");
        JButton brisanjeBtn = new JButton("Brisanje naloga");
        JButton odjavBtn = new JButton("Odjava");

        add(laboratorijeBtn);
        add(azuriranjeBtn);
        add(brisanjeBtn);
        add(odjavBtn);

        laboratorijeBtn.addActionListener(e -> {
            new LaboratorijeForm().setVisible(true);
            dispose();
        });

        azuriranjeBtn.addActionListener(e -> {
            new AzuriranjeNalogaForm(idKorisnika, korisnickoIme).setVisible(true);
            dispose();
        });

        brisanjeBtn.addActionListener(e -> {
            new BrisanjeNalogaForm(idKorisnika, korisnickoIme).setVisible(true);
            dispose();
        });

        odjavBtn.addActionListener(e -> {
            new LoginForm().setVisible(true);
            dispose();
        });
    }
}