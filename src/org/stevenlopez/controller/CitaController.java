package org.stevenlopez.controller;

import eu.schudt.javafx.controls.calendar.DatePicker;
import java.net.URL;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Time;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.ResourceBundle;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.control.ComboBox;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.TextField;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.layout.GridPane;
import javax.swing.JOptionPane;
import org.stevenlopez.bean.Cita;
import org.stevenlopez.bean.Doctor;
import org.stevenlopez.bean.Paciente;
import org.stevenlopez.db.Conexion;
import org.stevenlopez.report.GenerarReporte;
import org.stevenlopez.system.Principal;

public class CitaController implements Initializable{
    private enum operaciones{NUEVO,GUARDAR,ELIMINAR,ACTUALIZAR,CANCELAR,NINGUNO};
    private operaciones tipoDeOperacion = operaciones.NINGUNO;
    private Principal escenarioPrincipal;
    private ObservableList<Cita> listaCita;
    private ObservableList<Doctor> listaDoctor;
    private ObservableList<Paciente> listaPaciente;
    private DatePicker fCita;
    @FXML private GridPane grpFechas;
    @FXML private TextField txtTratamiento;
    @FXML private TextField txtCondicion;
    @FXML private TextField txtHoraCita;
    @FXML private ComboBox cmbCodigoPaciente;
    @FXML private ComboBox cmbNumeroColegiado;
    @FXML private TableView tblCitas;
    @FXML private TableColumn colCodigoCita;
    @FXML private TableColumn colTratamiento;
    @FXML private TableColumn colCondicion;
    @FXML private TableColumn colFechaCita;
    @FXML private TableColumn colHoraCita;
    @FXML private TableColumn colCodigoPaciente;
    @FXML private TableColumn colNumeroColegiado;
    @FXML private Button btnNuevo;
    @FXML private Button btnEliminar;
    @FXML private Button btnEditar;
    @FXML private Button btnReporte;
    @FXML private ImageView imgNuevo;
    @FXML private ImageView imgEliminar;
    @FXML private ImageView imgEditar;
    @FXML private ImageView imgReporte;
    

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        cargarDatos();
        cmbNumeroColegiado.setItems(getDoctor());
        cmbCodigoPaciente.setItems(getPaciente());
        fCita = new DatePicker(Locale.ENGLISH);
        fCita.setDateFormat(new SimpleDateFormat("yyy-MM-dd"));
        fCita.getCalendarView().todayButtonTextProperty().set("Today");
        fCita.getCalendarView().setShowWeeks(false);
        grpFechas.add(fCita, 3, 1);
        fCita.getStylesheets().add("/org/stevenlopez/resource/DatePicker.css");
    }
    
    public void cargarDatos(){
        tblCitas.setItems(getCita());
        colCodigoCita.setCellValueFactory(new PropertyValueFactory<Cita, Integer>("codigoCita"));
        colTratamiento.setCellValueFactory(new PropertyValueFactory<Cita, String>("tratamiento"));
        colCondicion.setCellValueFactory(new PropertyValueFactory<Cita, String>("descripCondActual"));
        colFechaCita.setCellValueFactory(new PropertyValueFactory<Cita, Date>("fechaCita"));
        colHoraCita.setCellValueFactory(new PropertyValueFactory<Cita, String>("horaCita"));
        colCodigoPaciente.setCellValueFactory(new PropertyValueFactory<Cita, Integer>("codigoPaciente"));
        colNumeroColegiado.setCellValueFactory(new PropertyValueFactory<Cita, Integer>("numeroColegiado"));
    }
    
    
    public ObservableList<Cita> getCita(){
        ArrayList<Cita> lista = new ArrayList<Cita>();
        try{
            PreparedStatement procedimiento = Conexion.getInstance().getConexion().prepareCall("{CALL sp_ListarCitas()}");
            ResultSet resultado = procedimiento.executeQuery();
            while(resultado.next()){
                lista.add(new Cita(resultado.getInt("codigoCita"), 
                        resultado.getDate("fechaCita"), 
                        resultado.getString("horaCita"),
                        resultado.getString("tratamiento"), 
                        resultado.getString("descripCondActual"), 
                        resultado.getInt("codigoPaciente"), 
                        resultado.getInt("numeroColegiado")));
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        return listaCita = FXCollections.observableArrayList(lista);
    }
    public ObservableList<Doctor> getDoctor(){
        ArrayList<Doctor> lista = new ArrayList<Doctor>();
        try{
            PreparedStatement procedimiento = Conexion.getInstance().getConexion().prepareCall("{call sp_ListarDoctores()}");
            ResultSet resultado = procedimiento.executeQuery();
            while(resultado.next()){
                lista.add(new Doctor(resultado.getInt("numeroColegiado"),
                                    resultado.getString("nombresDoctor"),
                                    resultado.getString("apellidosDoctor"),
                                    resultado.getString("telefonoContacto"),
                                    resultado.getInt("codigoEspecialidad")));
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        return listaDoctor = FXCollections.observableArrayList(lista);
    }
    public ObservableList<Paciente> getPaciente(){
        ArrayList<Paciente> lista = new ArrayList<Paciente>();
        try{
            PreparedStatement procedimiento = Conexion.getInstance().getConexion().prepareCall("{call sp_ListarPaciente()}");
            ResultSet resultado = procedimiento.executeQuery();
            while(resultado.next()){
                lista.add(new Paciente(resultado.getInt("codigoPaciente"),
                                    resultado.getString("nombresPaciente"),
                                    resultado.getString("apellidosPaciente"),
                                    resultado.getString("sexo"),
                                    resultado.getDate("fechaNacimiento"),
                                    resultado.getString("direccionPaciente"),
                                    resultado.getString("telefonoPersonal"),
                                    resultado.getDate("fechaPrimeraVisita")));
            }
        }catch(Exception e){
            e.printStackTrace();
        }        
        return listaPaciente = FXCollections.observableArrayList(lista);
    }
    
    public void seleccionarElemento(){
        try{
            txtTratamiento.setText(((Cita)tblCitas.getSelectionModel().getSelectedItem()).getTratamiento());
            txtCondicion.setText(((Cita)tblCitas.getSelectionModel().getSelectedItem()).getDescripCondActual());  
            txtHoraCita.setText(((Cita)tblCitas.getSelectionModel().getSelectedItem()).getHoraCita());
            cmbCodigoPaciente.getSelectionModel().select(buscarPaciente(((Cita)tblCitas.getSelectionModel().getSelectedItem()).getCodigoPaciente()));
            cmbNumeroColegiado.getSelectionModel().select(buscarDoctor(((Cita)tblCitas.getSelectionModel().getSelectedItem()).getCodigoPaciente()));
            fCita.selectedDateProperty().set(((Cita)tblCitas.getSelectionModel().getSelectedItem()).getFechaCita());
        }catch(Exception e){
            JOptionPane.showMessageDialog(null, "Sin elementos");
        }                   
    }
    
    public Paciente buscarPaciente(int codigoPaciente){
        Paciente resultado = null;
        try{
            PreparedStatement procedimiento = Conexion.getInstance().getConexion().prepareCall("{call sp_BuscarPaciente(?)}");
            procedimiento.setInt(1, codigoPaciente);
            ResultSet registro = procedimiento.executeQuery();
            while(registro.next()){
                resultado = new Paciente(registro.getInt("codigoPaciente"),
                                             registro.getString("nombresPaciente"), 
                                             registro.getString("apellidosPaciente"), 
                                             registro.getString("sexo"), 
                                             registro.getDate("fechaNacimiento"), 
                                             registro.getString("direccionPaciente"), 
                                             registro.getString("telefonoPersonal"), 
                                             registro.getDate("fechaPrimeraVisita"));
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        return resultado;
    }    
    public Doctor buscarDoctor(int codigoDoctor){
        Doctor resultado = null;
        try{
            PreparedStatement procedimiento = Conexion.getInstance().getConexion().prepareCall("{call sp_BuscarDoctores(?)}");
            procedimiento.setInt(1, codigoDoctor);
            ResultSet registro = procedimiento.executeQuery();
            while(registro.next()){
                resultado = new Doctor(registro.getInt("numeroColegiado"),
                                       registro.getString("nombresDoctor"),
                                       registro.getString("apellidosDoctor"),
                                       registro.getString("telefonoContacto"),
                                       registro.getInt("codigoEspecialidad"));
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        return resultado;
    }   
    
    public void nuevo(){
        switch(tipoDeOperacion){
            case NINGUNO:
                activarControles();
                btnNuevo.setText("Guardar");
                btnEliminar.setText("Cancelar");
                btnEditar.setDisable(true);
                btnReporte.setDisable(true);
                imgNuevo.setImage(new Image("/org/stevenlopez/image/Guardar.png"));
                imgEliminar.setImage(new Image("/org/stevenlopez/image/Cancelar.png"));
                tipoDeOperacion = operaciones.GUARDAR;
                break;
            case GUARDAR:
                guardar();
                desactivarControles();
                limpiarControles();
                btnNuevo.setText("Nuevo");
                btnEliminar.setText("Eliminar");
                btnEditar.setDisable(false);
                btnReporte.setDisable(false);
                imgNuevo.setImage(new Image("/org/stevenlopez/image/Nuevo.png"));
                imgEliminar.setImage(new Image("/org/stevenlopez/image/Eliminar2.png"));
                tipoDeOperacion = operaciones.NINGUNO;
                cargarDatos();
                break;
        }
    }
    
    public void guardar(){
        Cita registro = new Cita();
        registro.setTratamiento(txtTratamiento.getText());
        registro.setDescripCondActual(txtCondicion.getText());
        registro.setHoraCita(txtHoraCita.getText());
        registro.setFechaCita(fCita.getSelectedDate());
        registro.setNumeroColegiado(((Doctor)cmbNumeroColegiado.getSelectionModel().getSelectedItem()).getNumeroColegiado());
        registro.setCodigoPaciente(((Paciente)cmbCodigoPaciente.getSelectionModel().getSelectedItem()).getCodigoPaciente());
        try{
            PreparedStatement procedimiento = Conexion.getInstance().getConexion().prepareCall("{call sp_AgregarCita(?,?,?,?,?,?)}");
            procedimiento.setString(1, registro.getDescripCondActual());
            procedimiento.setString(2, registro.getTratamiento());
            procedimiento.setInt(3, registro.getCodigoPaciente());
            procedimiento.setInt(4, registro.getNumeroColegiado());
            procedimiento.setDate(5, new java.sql.Date(registro.getFechaCita().getTime()));
            procedimiento.setString(6, registro.getHoraCita());
            procedimiento.execute();
            listaCita.add(registro);
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    
    public void eliminar(){
        switch(tipoDeOperacion){
            case GUARDAR:
                desactivarControles();
                limpiarControles();
                btnNuevo.setText("Nuevo");
                btnEliminar.setText("Eliminar");
                btnEditar.setDisable(false);
                btnReporte.setDisable(false);
                imgNuevo.setImage(new Image("/org/stevenlopez/image/Nuevo.png"));
                imgEliminar.setImage(new Image("/org/stevenlopez/image/Eliminar2.png"));
                tipoDeOperacion = operaciones.NINGUNO;                 
                cargarDatos();
                break;
            default:
                if(tblCitas.getSelectionModel().getSelectedItem() != null){
                        int respuesta = JOptionPane.showConfirmDialog(null, "¿Esta seguro de eleminar el registro?","Eliminar Cita", JOptionPane.YES_NO_OPTION, JOptionPane.QUESTION_MESSAGE);
                        if(respuesta == JOptionPane.YES_OPTION){
                            try{
                                PreparedStatement procedimiento = Conexion.getInstance().getConexion().prepareCall("{call sp_EliminarCita(?)}");
                                    procedimiento.setInt(1, ((Cita)tblCitas.getSelectionModel().getSelectedItem()).getCodigoPaciente());
                                    procedimiento.execute();
                                    listaPaciente.remove(tblCitas.getSelectionModel().getSelectedIndex());
                                    limpiarControles();
                            }catch(Exception e){
                                    e.printStackTrace();                                    
                            }
                                }                        
                        }else{
                                JOptionPane.showMessageDialog(null, "Debe seleccionar un elemento");
                        }
        }
    }
    
    public void editar(){
        switch(tipoDeOperacion){
            case NINGUNO:
                if(tblCitas.getSelectionModel().getSelectedItem() != null){
                    btnEditar.setText("Actualizar");
                    btnReporte.setText("Cancelar");
                    btnNuevo.setDisable(true);
                    btnEliminar.setDisable(true);
                    imgEditar.setImage(new Image("/org/stevenlopez/image/Actualizar.png"));
                    imgReporte.setImage(new Image("/org/stevenlopez/image/Cancelar.png"));
                    activarControles();                    
                    tipoDeOperacion = operaciones.ACTUALIZAR;
                }else{
                    JOptionPane.showMessageDialog(null, "Debe seleccionar un elemento");
                }
                break;
            case ACTUALIZAR:
                actualizar();
                btnEditar.setText("Editar");
                btnReporte.setText("Reporte");
                btnNuevo.setDisable(false);
                btnEliminar.setDisable(false);
                imgEditar.setImage(new Image("/org/stevenlopez/image/Editar2.png"));
                imgReporte.setImage(new Image("/org/stevenlopez/image/Reporte.png"));
                desactivarControles();
                limpiarControles();
                tipoDeOperacion = operaciones.NINGUNO;
                cargarDatos();
                break;
        }
    }
    
    public void actualizar(){
        try{
            PreparedStatement procedimiento = Conexion.getInstance().getConexion().prepareCall("{call sp_EditarCita(?,?,?,?,?)}");
            Cita registro = (Cita)tblCitas.getSelectionModel().getSelectedItem();
            registro.setTratamiento(txtTratamiento.getText());
            registro.setDescripCondActual(txtCondicion.getText());
            registro.setHoraCita(txtHoraCita.getText());
            registro.setFechaCita(fCita.getSelectedDate());      
            procedimiento.setInt(1, registro.getCodigoCita());
            procedimiento.setString(2, registro.getDescripCondActual());
            procedimiento.setString(3, registro.getTratamiento());
            procedimiento.setDate(4, new java.sql.Date(registro.getFechaCita().getTime()));                       
            procedimiento.setString(5, registro.getHoraCita());
            procedimiento.execute();
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    
    public void reporte(){
        switch(tipoDeOperacion){
            case NINGUNO:
                imprimirReporte();
                break;
            case ACTUALIZAR:
                desactivarControles();
                limpiarControles();                
                btnEditar.setText("Editar");
                btnReporte.setText("Reporte");
                btnNuevo.setDisable(false);
                btnEliminar.setDisable(false);
                imgEditar.setImage(new Image("/org/stevenlopez/image/Editar2.png"));
                imgReporte.setImage(new Image("/org/stevenlopez/image/Reporte.png"));
                tipoDeOperacion = operaciones.NINGUNO;
                break;
        }
    }
    public void imprimirReporte(){
        Map parametros = new HashMap();
        parametros.put("codigoCita", null);
        parametros.put("FondoReporte", GenerarReporte.class.getResource("/org/stevenlopez/image/FondoReporte.png"));
        GenerarReporte.mostrarReporte("ReporteCita.jasper", "Reporte de Citas", parametros);
    }
    
    
    public void desactivarControles(){
        txtTratamiento.setEditable(false);
        txtCondicion.setEditable(false);
        txtHoraCita.setEditable(false);
        cmbCodigoPaciente.setDisable(true);
        cmbNumeroColegiado.setDisable(true);        
    }
    public void activarControles(){
        txtTratamiento.setEditable(true);
        txtCondicion.setEditable(true);
        txtHoraCita.setEditable(true);
        cmbCodigoPaciente.setDisable(false);
        cmbNumeroColegiado.setDisable(false);        
    }
    public void limpiarControles(){
        txtTratamiento.clear();
        txtCondicion.clear();
        txtHoraCita.clear();
        cmbCodigoPaciente.getSelectionModel().clearSelection();
        cmbNumeroColegiado.getSelectionModel().clearSelection(); 
        fCita = null;
        fCita = new DatePicker(Locale.ENGLISH);
        fCita.setDateFormat(new SimpleDateFormat("yyyy-MM-dd"));
        fCita.getCalendarView().todayButtonTextProperty().set("Today");
        fCita.getCalendarView().setShowWeeks(false);
        grpFechas.add(fCita, 3, 1);
        fCita.getStylesheets().add("/org/stevenlopez/resource/DatePicker.css");
    }

    public Principal getEscenarioPrincipal() {
        return escenarioPrincipal;
    }
    public void setEscenarioPrincipal(Principal escenarioPrincipal) {
        this.escenarioPrincipal = escenarioPrincipal;
    }    
    public void menuPrincipal(){
        escenarioPrincipal.menuPrincipal();
    }
    
}
