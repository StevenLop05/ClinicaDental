/*
 Nombre completo: Steven Alejandro López del Cid
 Código Técnico: IN5AM
 Carnet: 2018151
 Fecha de creación: 5/4/2022
 Modificaciones: 19/04/2022 | 20/04/2022 | 25/04/2022 | 26/04/22 | 03/05/2022 | 23/05/2022 | 06/06/2022
 */

package org.stevenlopez.system;

import java.io.InputStream;
import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.fxml.JavaFXBuilderFactory;
import javafx.scene.Scene;
import javafx.scene.image.Image;
import javafx.scene.layout.AnchorPane;
import javafx.stage.Stage;
import org.stevenlopez.controller.CitaController;
import org.stevenlopez.controller.DetalleRecetaController;
import org.stevenlopez.controller.DoctorController;
import org.stevenlopez.controller.EspecialidadController;
import org.stevenlopez.controller.LoginController;
import org.stevenlopez.controller.MedicamentoController;
import org.stevenlopez.controller.MenuPrincipalController;
import org.stevenlopez.controller.PacienteController;
import org.stevenlopez.controller.ProgramadorController;
import org.stevenlopez.controller.RecetaController;
import org.stevenlopez.controller.UsuarioController;

public class Principal extends Application {
    private final String PAQUETE_VISTA = "/org/stevenlopez/view/";
    private Stage escenarioPrincipal;
    private Scene escena;
    
    @Override
    public void start(Stage escenarioPrincipal) throws Exception {
        this.escenarioPrincipal = escenarioPrincipal;
        this.escenarioPrincipal.setTitle("ClinaMex 2022");
        escenarioPrincipal.getIcons().add(new Image("/org/stevenlopez/image/Logo.png"));
        ventanaLogin();
        escenarioPrincipal.show();
        
        
    } 
    
    public void ventanaLogin(){
        try{
            LoginController login = (LoginController)cambiarEscena("LoginView.fxml",615,400);
            login.setEscenarioPrincipal(this);
        }catch(Exception e){
            e.printStackTrace();
        }
            
    }    
    public void ventanaUsuario(){
        try{
            UsuarioController usuario = (UsuarioController)cambiarEscena("UsuariosView.fxml",721,422);
            usuario.setEscenarioPrincipal(this);
        }catch(Exception e){
            e.printStackTrace();
        }
    }    
    public void menuPrincipal(){
        try{
            MenuPrincipalController ventanaMenu = (MenuPrincipalController)cambiarEscena("MenuPrincipalView.fxml",600,400);
            ventanaMenu.setEscenarioPrincipal(this);
        }catch(Exception e){
            e.printStackTrace();
        }
    }    
    public void ventanaProgramador(){
        try{
            ProgramadorController ventanaProgramador = (ProgramadorController)cambiarEscena("ProgramadorView.fxml",597,361);
            ventanaProgramador.setEscenarioPrincipal(this);
        }catch(Exception e){
            e.printStackTrace();
        }
    }    
    public void ventanaPacientes(){
        try{
            PacienteController ventanaPacientes = (PacienteController)cambiarEscena("PacientesView.fxml",994,422);
            ventanaPacientes.setEscenarioPrincipal(this);
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    public void ventanaEspecialidad(){
        try{
            EspecialidadController ventanaEspecialidad = (EspecialidadController)cambiarEscena("EspecialidadesView.fxml",721,422);
            ventanaEspecialidad.setEscenarioPrincipal(this);
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    public void ventanaMedicamento(){
        try{
            MedicamentoController ventanaMedicamentos = (MedicamentoController)cambiarEscena("MedicamentosView.fxml",721,422);
            ventanaMedicamentos.setEscenarioPrincipal(this);
        }catch(Exception e){
            e.printStackTrace();
        }
    }    
    public void ventanaDoctor(){
        try{
            DoctorController vistaDoctores = (DoctorController)cambiarEscena("DoctoresView.fxml",994,400);
            vistaDoctores.setEscenarioPrincipal(this);
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    public void ventanaReceta(){
        try{
            RecetaController vistaRecetas = (RecetaController)cambiarEscena("RecetasView.fxml",721,422);
            vistaRecetas.setEscenarioPrincipal(this);
        }catch(Exception e){
            e.printStackTrace();
        }
    }    
    public void ventanaDetalleReceta(){
        try{
            DetalleRecetaController vistaDetalleReceta = (DetalleRecetaController)cambiarEscena("DetalleRecetaView.fxml",994,422);
            vistaDetalleReceta.setEscenarioPrincipal(this);
        }catch(Exception e){
            e.printStackTrace();
        }
    }           
    public void ventanaCita(){
        try{
            CitaController vistaCita = (CitaController)cambiarEscena("CitasView.fxml",994,422);
            vistaCita.setEscenarioPrincipal(this);
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    
    public static void main(String[] args) {
        launch(args);        
    }
    
    public Initializable cambiarEscena(String fxml, int ancho, int alto)throws Exception{
        Initializable resultado = null;
        FXMLLoader cargadorFXML = new FXMLLoader();
        InputStream archivo = Principal.class.getResourceAsStream(PAQUETE_VISTA+fxml);
        cargadorFXML.setBuilderFactory(new JavaFXBuilderFactory());
        cargadorFXML.setLocation(Principal.class.getResource(PAQUETE_VISTA+fxml));
        escena = new Scene((AnchorPane)cargadorFXML.load(archivo),ancho,alto);
        escenarioPrincipal.setScene(escena);
        escenarioPrincipal.sizeToScene();
        resultado = (Initializable)cargadorFXML.getController();                
        return resultado;        
    }   
}
