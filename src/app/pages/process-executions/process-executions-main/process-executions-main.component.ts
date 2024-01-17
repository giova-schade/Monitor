import { Component, ViewChild} from '@angular/core';
import { ConfirmationService, MessageService } from 'primeng/api';
import { SasService } from 'src/app/services/sas.service';
import { Table } from "primeng/table";
import { ActivatedRoute } from '@angular/router';


@Component({
  selector: 'app-process-executions-main',
  templateUrl: './process-executions-main.component.html',
  styleUrls: ['./process-executions-main.component.scss'],
  providers: [ConfirmationService, MessageService]
})
export class ProcessExecutionsMainComponent {
  loadingPage: boolean;
  datasource: any;
  totalRecords: number;
  @ViewChild('datos') datos!: Table;
  multiSortSegmento: any;
  LogsCampos: any;
  Logsview: boolean;
  loading!: boolean;
  idProceso: string | null = null;






  constructor(
    private sasService: SasService,
    private messageService: MessageService,
    private route: ActivatedRoute
  ) {
    this.loadingPage = false;
    this.totalRecords = 0;
    this.multiSortSegmento = [];
    this.LogsCampos = [];
    this.Logsview = false;



  }
  ngOnInit() {
    this.route.queryParams.subscribe(params => {
      this.idProceso = params['id_proceso'] ?? '';
      this.loadDataAndFilter(this.idProceso);
    });
  }
  public reload(){
    this.loadingPage = true;
    this.sasService.getDatalog('common/getMonitor', "").then((data: any) => {
      const estado = data.status[0].ESTADO;
      if (estado === "nook") {
        this.messageService.add({
          severity: "warn",
          detail: data.status[0].MENSAJE,
          
        });
        this.loadingPage = false;
      } else {
        this.datasource = data.datos;
        this.totalRecords = this.datasource.length;

        if (this.totalRecords) {
          this.LogsCampos = Object.keys(this.datasource[0]).map(campo => ({ field: campo, header: campo }));
        }
        this.loading = false;
        this.loadingPage = false;
        this.Logsview = true;

       
      }
    }).catch((error: any) => {
      this.messageService.add({
        severity: "error",
        detail: 'Error al listar los datos',
      });
      this.loadingPage = false;
    });
  }
  public loadDataAndFilter(idProceso:any) {
    this.loadingPage = true;
    this.sasService.getDatalog('common/getMonitor', idProceso).then((data: any) => {
      const estado = data.status[0].ESTADO;
      if (estado === "nook") {
        this.messageService.add({
          severity: "warn",
          detail: data.status[0].MENSAJE,
          
        });
        this.loadingPage = false;
      } else {
        this.datasource = data.datos;
        this.totalRecords = this.datasource.length;

        if (this.totalRecords) {
          this.LogsCampos = Object.keys(this.datasource[0]).map(campo => ({ field: campo, header: campo }));
        }
        this.loading = false;
        this.loadingPage = false;
        this.Logsview = true;

       
      }
    }).catch((error: any) => {
      this.messageService.add({
        severity: "error",
        detail: 'Error al listar los datos',
      });
      this.loadingPage = false;
    });
  }
  
  applyFilterGlobal($event: any, stringVal: any) {
    this.datos.filterGlobal($event.target.value, 'contains');

  }

  clear(table: Table) {
    table.clear();
  }

}
