package gui;

import db.DBKonekcija;

import javax.swing.*;
import java.awt.*;
import java.sql.*;

public class BrisanjeNalogaForm extends JFrame {

    private int idKorisnika;
    private String korisnickoIme;
    private JPasswordField lozinkaField;

    public BrisanjeNalogaForm(int idKorisnika, String korisnickoIme) {
        this.idKorisnika = idKorisnika;
        this.korisnickoIme = korisnickoIme;

        setTitle("Brisanje naloga");
        setSize(350, 180);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLocationRelativeTo(null);
        setLayout(new GridLayout(3, 2, 10, 10));

        add(new JLabel("Unesite lozinku za potvrdu:"));
        lozinkaField = new JPasswordField();
        add(lozinkaField);

        JButton obrisiBtn = new JButton("Obrisi nalog");
        JButton nazadBtn = new JButton("Nazad");
        add(obrisiBtn);
        add(nazadBtn);

        obrisiBtn.addActionListener(e -> obrisi());
        nazadBtn.addActionListener(e -> {
            new GlavniMeni(idKorisnika, korisnickoIme).setVisible(true);
            dispose();
        });

        setVisible(true);
    }

    private void obrisi() {
        String lozinka = new String(lozinkaField.getPassword());

        try (Connection conn = DBKonekcija.getKonekcija()) {
            String provjera = "SELECT * FROM KORISNIK WHERE id_korisnika = ? AND lozinka = ?";
            PreparedStatement ps = conn.prepareStatement(provjera);
            ps.setInt(1, idKorisnika);
            ps.setString(2, lozinka);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                int potvrda = JOptionPane.showConfirmDialog(this,
                        "Da li ste sigurni da zelite obrisati nalog?",
                        "Potvrda", JOptionPane.YES_NO_OPTION);

                if (potvrda == JOptionPane.YES_OPTION) {
                    String brisanje = "DELETE FROM KORISNIK WHERE id_korisnika = ?";
                    PreparedStatement psBrisanje = conn.prepareStatement(brisanje);
                    psBrisanje.setInt(1, idKorisnika);
                    psBrisanje.executeUpdate();

                    JOptionPane.showMessageDialog(this, "Nalog je obrisan.");
                    new LoginForm().setVisible(true);
                    dispose();
                }
            } else {
                JOptionPane.showMessageDialog(this, "Pogresna lozinka!");
            }
        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(this, "Greska: " + ex.getMessage());
        }
    }
}