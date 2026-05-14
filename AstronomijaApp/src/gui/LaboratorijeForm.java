package gui;

import db.DBKonekcija;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.sql.*;

public class LaboratorijeForm extends JFrame {

    private JTable tabela;
    private DefaultTableModel model;
    private JComboBox<String> opservatorijeCB;

    public LaboratorijeForm(int idKorisnika, String korisnickoIme) {
        setTitle("Pregled laboratorija i istrazivaca");
        setSize(800, 500);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLocationRelativeTo(null);
        setLayout(new BorderLayout(10, 10));

        JPanel gornji = new JPanel(new FlowLayout());
        gornji.add(new JLabel("Izaberi opservatoriju:"));
        opservatorijeCB = new JComboBox<>();
        gornji.add(opservatorijeCB);
        JButton prikaziBtn = new JButton("Prikazi istrazivace");
        gornji.add(prikaziBtn);
        JButton nazadBtn = new JButton("Nazad");
        gornji.add(nazadBtn);
        add(gornji, BorderLayout.NORTH);

        model = new DefaultTableModel();
        model.addColumn("Ime");
        model.addColumn("Prezime");
        model.addColumn("Email");
        model.addColumn("Zvanje");
        model.addColumn("Specijalizacija");
        model.addColumn("God. iskustva");
        tabela = new JTable(model);
        add(new JScrollPane(tabela), BorderLayout.CENTER);

        ucitajOpservatorije();

        prikaziBtn.addActionListener(e -> ucitajIstrazivace());
        nazadBtn.addActionListener(e -> {
            new GlavniMeni(idKorisnika, korisnickoIme).setVisible(true);
            dispose();
        });

        setVisible(true);
    }

    private void ucitajOpservatorije() {
        try (Connection conn = DBKonekcija.getKonekcija()) {
            String sql = "SELECT DISTINCT o.naziv FROM OPSERVATORIJA o " +
                    "JOIN IZVODJENJE iz ON o.id_opservatorije = iz.id_opservatorije " +
                    "ORDER BY o.naziv";
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) {
                opservatorijeCB.addItem(rs.getString("naziv"));
            }
        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(this, "Greska: " + ex.getMessage());
        }
    }

    private void ucitajIstrazivace() {
        while (model.getRowCount() > 0) {
            model.removeRow(0);
        }

        String izabranaOps = (String) opservatorijeCB.getSelectedItem();

        try (Connection conn = DBKonekcija.getKonekcija()) {
            String sql = "SELECT i.ime, i.prezime, i.email, i.akademsko_zvanje, " +
                    "i.oblast_specijalizacije, i.godine_iskustva " +
                    "FROM ISTRAZIVAC i " +
                    "JOIN TIM_IZVODJACA ti ON i.id_istrazivaca = ti.id_istrazivaca " +
                    "JOIN IZVODJENJE iz ON ti.id_izvodjenja = iz.id_izvodjenja " +
                    "JOIN OPSERVATORIJA o ON iz.id_opservatorije = o.id_opservatorije " +
                    "WHERE o.naziv = ? " +
                    "GROUP BY i.id_istrazivaca";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, izabranaOps);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                model.addRow(new Object[]{
                        rs.getString("ime"),
                        rs.getString("prezime"),
                        rs.getString("email"),
                        rs.getString("akademsko_zvanje"),
                        rs.getString("oblast_specijalizacije"),
                        rs.getInt("godine_iskustva")
                });
            }

            if (model.getRowCount() == 0) {
                JOptionPane.showMessageDialog(this, "Nema istrazivaca za ovu opservatoriju.");
            }
        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(this, "Greska: " + ex.getMessage());
        }
    }
}