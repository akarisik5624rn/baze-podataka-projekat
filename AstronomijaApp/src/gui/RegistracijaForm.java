package gui;

import db.DBKonekcija;

import javax.swing.*;
import java.awt.*;
import java.sql.*;

public class RegistracijaForm extends JFrame {

    private JTextField korisnickoImeField;
    private JPasswordField lozinkaField;
    private JPasswordField potvrnaLozinkaField;

    public RegistracijaForm() {
        setTitle("Registracija");
        setSize(350, 230);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLocationRelativeTo(null);
        setLayout(new GridLayout(5, 2, 10, 10));

        add(new JLabel("Korisnicko ime:"));
        korisnickoImeField = new JTextField();
        add(korisnickoImeField);

        add(new JLabel("Lozinka:"));
        lozinkaField = new JPasswordField();
        add(lozinkaField);

        add(new JLabel("Potvrdi lozinku:"));
        potvrnaLozinkaField = new JPasswordField();
        add(potvrnaLozinkaField);

        JButton registrujBtn = new JButton("Registruj se");
        JButton nazadBtn = new JButton("Nazad");
        add(registrujBtn);
        add(nazadBtn);

        registrujBtn.addActionListener(e -> registracija());
        nazadBtn.addActionListener(e -> {
            new LoginForm().setVisible(true);
            dispose();
        });

        setVisible(true);
    }

    private void registracija() {
        String korisnickoIme = korisnickoImeField.getText().trim();
        String lozinka = new String(lozinkaField.getPassword());
        String potvrdaLozinke = new String(potvrnaLozinkaField.getPassword());

        if (korisnickoIme.isEmpty() || lozinka.isEmpty()) {
            JOptionPane.showMessageDialog(this, "Sva polja su obavezna!");
            return;
        }

        if (!lozinka.equals(potvrdaLozinke)) {
            JOptionPane.showMessageDialog(this, "Lozinke se ne poklapaju!");
            return;
        }

        try (Connection conn = DBKonekcija.getKonekcija()) {
            String sql = "INSERT INTO KORISNIK (korisnicko_ime, lozinka) VALUES (?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, korisnickoIme);
            ps.setString(2, lozinka);
            ps.executeUpdate();

            JOptionPane.showMessageDialog(this, "Registracija uspjesna!");
            new LoginForm().setVisible(true);
            dispose();
        } catch (SQLIntegrityConstraintViolationException ex) {
            JOptionPane.showMessageDialog(this, "Korisnicko ime vec postoji!");
        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(this, "Greska: " + ex.getMessage());
        }
    }
}