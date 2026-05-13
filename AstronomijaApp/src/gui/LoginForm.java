package gui;

import db.DBKonekcija;

import javax.swing.*;
import java.awt.*;
import java.sql.*;

public class LoginForm extends JFrame {

    private JTextField korisnickoImeField;
    private JPasswordField lozinkaField;

    public LoginForm() {
        setTitle("Prijava");
        setSize(350, 200);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLocationRelativeTo(null);
        setLayout(new GridLayout(4, 2, 10, 10));

        add(new JLabel("Korisnicko ime:"));
        korisnickoImeField = new JTextField();
        add(korisnickoImeField);

        add(new JLabel("Lozinka:"));
        lozinkaField = new JPasswordField();
        add(lozinkaField);

        JButton loginBtn = new JButton("Prijavi se");
        JButton registracijaBtn = new JButton("Registruj se");
        add(loginBtn);
        add(registracijaBtn);

        loginBtn.addActionListener(e -> prijava());
        registracijaBtn.addActionListener(e -> {
            new RegistracijaForm().setVisible(true);
            dispose();
        });

        setVisible(true);
    }

    private void prijava() {
        String korisnickoIme = korisnickoImeField.getText();
        String lozinka = new String(lozinkaField.getPassword());

        try (Connection conn = DBKonekcija.getKonekcija()) {
            String sql = "SELECT * FROM KORISNIK WHERE korisnicko_ime = ? AND lozinka = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, korisnickoIme);
            ps.setString(2, lozinka);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                int idKorisnika = rs.getInt("id_korisnika");
                JOptionPane.showMessageDialog(this, "Dobrodosli, " + korisnickoIme + "!");
                new GlavniMeni(idKorisnika, korisnickoIme).setVisible(true);
                dispose();
            } else {
                JOptionPane.showMessageDialog(this, "Pogresno korisnicko ime ili lozinka!");
            }
        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(this, "Greska: " + ex.getMessage());
        }
    }
}