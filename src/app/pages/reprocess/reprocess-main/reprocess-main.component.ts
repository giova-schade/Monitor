import { Component, OnInit } from '@angular/core';
import { Proceso } from './proceso.model';
import { MessageService } from 'primeng/api';
import { SasService } from 'src/app/services/sas.service';

@Component({
  selector: 'app-reprocess-main',
  templateUrl: './reprocess-main.component.html',
  styleUrls: ['./reprocess-main.component.scss'],
  providers: [MessageService]
})
export class ReprocessMainComponent implements OnInit {
  loadingPage: boolean;
  loading: boolean = true;

  procesos: Proceso[] = [];

  constructor(private messageService: MessageService, private sasService: SasService) {
    this.loadingPage= false;

  }

  ngOnInit(): void {
    this.loadingPage= true;


    this.sasService.request('common/getReprocess', null).then((respuesta: any) => {
      const estadoRes = respuesta.status[0].ESTADO;
      if (estadoRes.toLowerCase() === "ok") {
        console.log(respuesta)
        this.procesos = respuesta.datos;
        this.loading = false;

      } else {
        this.messageService.add({
          severity: "warn",
          detail: respuesta.result[0].MENSAJE,
        });
      }
      this.loadingPage = false;
    }).catch((error: any) => {
      this.messageService.add({
        severity: "error",
        detail: 'Error al listar los datos',
      });
      this.loadingPage = false;


    });

  }

  ejecutarProceso(proceso: Proceso) {
    this.loadingPage = true; 


    this.sasService.ejecutarReProceso('common/getReRun', proceso.ID_PROCESO);

    // Aquí puedes añadir cualquier acción que quieras realizar inmediatamente después de enviar la solicitud
    this.messageService.add({
      severity: "info",
      detail: `Solicitud de reprocesamiento enviada para ${proceso.NOMBRE_PROCESO}`,
    });
  
    this.loadingPage = false;
  }

}
