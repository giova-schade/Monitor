import { Component } from '@angular/core';
import { MessageService } from 'primeng/api';
import { SasService } from 'src/app/services/sas.service';
interface Regla {
  nombre: string;
  valorSeleccionado: number;
  descripcion: string;
  opciones: { label: string; value: number }[];
}

interface Proceso {
  nombre: string;
  reglas: Regla[];
}
interface Dato {
  IDFLUJO: number;
  NOMBRE_PROCESO: string;
  NOMBRE_FLUJO: string;
  ACTIVO: number;
}

interface Acumulador {
  [key: string]: Regla[];
}

@Component({
  selector: 'app-configuration-main',
  templateUrl: './configuration-main.component.html',
  styleUrls: ['./configuration-main.component.scss']
})
export class ConfigurationMainComponent {
  loadingPage: boolean;
  activeIndex: number = 0;
  procesos: any[] = [];

  constructor(private messageService: MessageService, private sasService: SasService) {
    this.loadingPage = false;
  }
  ngOnInit() {

    this.loadingPage = true;

    this.sasService.request('common/getReglas', null).then((respuesta: any) => {
      const estadoRes = respuesta.status[0].ESTADO;
      if (estadoRes.toLowerCase() === "ok") {
        this.procesos = this.transformarReglasAProcesos(respuesta);

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

  private transformarReglasAProcesos(datos: any): Proceso[] {
    const procesosTransformados: Proceso[] = [];

    if (datos && datos.datos && Array.isArray(datos.datos)) {
      const agrupadoPorFlujo = datos.datos.reduce((acc: Acumulador, current: Dato) => {
        const flujo = acc[current.NOMBRE_FLUJO] || [];
        flujo.push({
          nombre: current.NOMBRE_PROCESO,
          valorSeleccionado: current.ACTIVO,
          descripcion: '', // La descripción no está presente en el nuevo formato
          opciones: [
            { label: 'Activado', value: 1 },
            { label: 'Desactivado', value: 0 }
          ]
        });
        acc[current.NOMBRE_FLUJO] = flujo;
        return acc;
      }, {});

      for (const nombreFlujo in agrupadoPorFlujo) {
        procesosTransformados.push({
          nombre: nombreFlujo,
          reglas: agrupadoPorFlujo[nombreFlujo]
        });
      }
    }

    return procesosTransformados;
  }



  public cambiarEstadoRegla(regla: Regla, procNombre: string) {
    this.loadingPage = true;

    const payload = {
      nombreProc: procNombre,
      nombreRegla: regla.nombre,
      nuevoEstado: regla.valorSeleccionado
    };

    this.sasService.actualizarRegla('common/updateReglas', payload).then(
      (respuesta: any) => {
        this.messageService.add({
          severity: "success",
          detail: `El proceso ${procNombre} cuya regla ${regla.nombre} ha sido ${regla.valorSeleccionado === 1 ? 'Activada' : 'Desactivada'}.`,
        });
      },
      (error: any) => {
        this.messageService.add({
          severity: "error",
          detail: 'Error al actualizar la regla',
        });
        // Manejar el error
      }
    ).finally(() => {
      this.loadingPage = false;
    });
  }



  public handleChange(event: any) {

  }
}
