
package org.stevenlopez.controller;

import java.net.URL;
import java.util.ResourceBundle;
import javafx.event.ActionEvent;
import javafx.fxml.Initializable;
import org.stevenlopez.system.Principal;

public class MenuPrincipalController implements Initializable{
    private Principal escenarioPrincipal;
    @Override
    public void initialize(URL location, ResourceBundle resources) {
        
    }
    public void cerrar(ActionEvent event) {
    System.exit(0);
}

    
    public Principal getEscenarioPrincipal() {
        return escenarioPrincipal;
    }

    public void setEscenarioPrincipal(Principal escenarioPrincipal) {
        this.escenarioPrincipal = escenarioPrincipal;
    }
    
    public void ventanaProgramador(){
        escenarioPrincipal.ventanaProgramador();
    }
    public void ventanaPacientes(){
        escenarioPrincipal.ventanaPacientes();
    }
    
    public void ventanaEspecialidad(){
        escenarioPrincipal.ventanaEspecialidad();
    }
    public void ventanaMedicamento(){
        escenarioPrincipal.ventanaMedicamento();
    }
    public void ventanaDoctor(){
        escenarioPrincipal.ventanaDoctor();
    }
    public void ventanaReceta(){
        escenarioPrincipal.ventanaReceta();
    }
    public void ventanaDetalleReceta(){
        escenarioPrincipal.ventanaDetalleReceta();
    }
    public void ventanaLogin(){
        escenarioPrincipal.ventanaLogin();
    }
    public void ventanaUsuario(){
        escenarioPrincipal.ventanaUsuario();
    }
    public void ventanaCita(){
        escenarioPrincipal.ventanaCita();
    }
}
