package gui;

import db.DBKonekcija;

import javax.swing.*;
import java.awt.*;
import java.sql.*;

public class AzuriranjeNalogaForm extends JFrame {

    private int idKorisnika;
    private String korisnickoIme;
    private JTextField novoKorisnickoImeField;
    private JPasswordField novaLozinkaField;
    private JPasswordField potvrdalozinkaField;

    public AzuriranjeNalogaForm(int idKorisnika, String korisnickoIme) {
        this.idKorisnika = idKorisnika;
        this.korisnickoIme = korisnickoIme;

        setTitle("Azuriranje naloga");
        setSize(350, 250);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLocationRelativeTo(null);
        setLayout(new GridLayout(5, 2, 10, 10));

        add(new JLabel("Novo korisnicko ime:"));
        novoKorisnickoImeField = new JTextField(korisnickoIme);
        add(novoKorisnickoImeField);

        add(new JLabel("Nova lozinka:"));
        novaLozinkaField = new JPasswordField();
        add(novaLozinkaField);

        add(new JLabel("Potvrdi lozinku:"));
        potvrdalozinkaField = new JPasswordField();
        add(potvrdalozinkaField);

        JButton sacuvajBtn = new JButton("Sacuvaj");
        JButton nazadBtn = new JButton("Nazad");
        add(sacuvajBtn);
        add(nazadBtn);

        sacuvajBtn.addActionListener(e -> azuriraj());
        nazadBtn.addActionListener(e -> {
            new GlavniMeni(idKorisnika, korisnickoIme).setVisible(true);
            dispose();
        });

        setVisible(true);
    }

    private void azuriraj() {
        String novoKorisnickoIme = novoKorisnickoImeField.getText().trim();
        String novaLozinka = new String(novaLozinkaField.getPassword());
        String potvrdaLozinke = new String(potvrdalozinkaField.getPassword());

        if (novoKorisnickoIme.isEmpty() || novaLozinka.isEmpty()) {
            JOptionPane.showMessageDialog(this, "Sva polja su obavezna!");
            return;
        }

        if (!novaLozinka.equals(potvrdaLozinke)) {
            JOptionPane.showMessageDialog(this, "Lozinke se ne poklapaju!");
            return;
        }

        try (Connection conn = DBKonekcija.getKonekcija()) {
            String sql = "UPDATE KORISNIK SET korisnicko_ime = ?, lozinka = ? WHERE id_korisnika = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, novoKorisnickoIme);
            ps.setString(2, novaLozinka);
            ps.setInt(3, idKorisnika);
            ps.executeUpdate();

            JOptionPane.showMessageDialog(this, "Nalog uspjesno azuriran!");
            new GlavniMeni(idKorisnika, novoKorisnickoIme).setVisible(true);
            dispose();
        } catch (SQLIntegrityConstraintViolationException ex) {
            JOptionPane.showMessageDialog(this, "Korisnicko ime vec postoji!");
        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(this, "Greska: " + ex.getMessage());
        }
    }
}