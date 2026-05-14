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
        setLayout(new BorderLayout());
        JPanel panel = new JPanel(new GridLayout(4, 1, 10, 10));
        panel.setBorder(BorderFactory.createEmptyBorder(20, 20, 20, 20));
        add(panel, BorderLayout.CENTER);

        JButton laboratorijeBtn = new JButton("Pregled laboratorija i istrazivaca");
        JButton azuriranjeBtn = new JButton("Azuriranje korisnickog imena i lozinke");
        JButton brisanjeBtn = new JButton("Brisanje naloga");
        JButton odjavBtn = new JButton("Odjava");

        panel.add(laboratorijeBtn);
        panel.add(azuriranjeBtn);
        panel.add(brisanjeBtn);
        panel.add(odjavBtn);

        laboratorijeBtn.addActionListener(e -> {
            new LaboratorijeForm(idKorisnika, korisnickoIme).setVisible(true);
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