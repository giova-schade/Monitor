import { Injectable } from '@angular/core'

import SASjs, { UploadFile } from '@sasjs/adapter'
import { StateService } from './state.service'
import { HttpClient, HttpHeaders, HttpResponse } from '@angular/common/http';
import { BehaviorSubject, Observable } from 'rxjs';
import { AbstractControl } from '@angular/forms';
import { AuthService } from './auth.services';
import { Router } from '@angular/router';
import { Role } from '../models/role';
import { ReplaySubject } from 'rxjs';
import { stringify } from 'querystring';
import { Regla } from './regla.interface';
@Injectable({
  providedIn: 'root'
})
export class SasService {
  private adapter: SASjs
  private _dataLoaded = new BehaviorSubject<boolean>(false);
  public dataLoaded$ = this._dataLoaded.asObservable();
  constructor(private http: HttpClient, private stateService: StateService, private authService: AuthService, private router: Router) {
    let sasjsConfigInput = (window as any).sasjsConfigInput || {}

    this.adapter = new SASjs(sasjsConfigInput)
  }


  public fetchStartupData() {
    this.request('common/appinit', null).then((response: any) => {
      this.stateService.setStartupData(response)
      this.SetLogin(response.groups[0].ROLE, response.groups[0].NOMBRE, '', '');
    }).catch(error => {
    })
  }



  public SetLogin(role: any, name: string, info: any, urlvalid: any) {
    this.authService.login(role, name, info, urlvalid);

    if (!this.authService.isAuthorized()) {
    } else {
      const validRol = Role;
      const rol = this.authService['user'].role as Role;

    }
  }


  public getDataField(url: string, field: any, config?: any){
    url = 'services/' + url
    const data: { [key: string]: Array<{ [key: string]: any }> } = {
      'archivo': []
    };
    const archivo: { [key: string]: any } = {};
    archivo["field"] = field;
    data['archivo'].push(archivo);
    return new Promise((resolve, reject) => {
      this.adapter
        .request(url, data, config, () => {
          this.stateService.setIsLoggedIn(false)
        })
        .then(
          (res: any) => {
            if (res.login === false) {
              this.stateService.setIsLoggedIn(false)
              this.stateService.username.next('')
              reject(false)
            }

            if (
              this.stateService.username.getValue().length < 1 &&
              res.MF_GETUSER
            ) {
              this.stateService.username.next(res.MF_GETUSER)
            }

            if (res.status === 404) {
              reject({ MESSAGE: res.body || 'SAS responded with an error' })
            }

            resolve(res)
          },
          (err: any) => {
            reject(err)
          }
        )
    })
  }
  public getDatalog(url: string, field: any, config?: any){
    url = 'services/' + url
    const data: { [key: string]: Array<{ [key: string]: any }> } = {
      'paramlog': []
    };
    const paramlog: { [key: string]: any } = {};
    paramlog["field"] = field;
    data['paramlog'].push(paramlog);
    return new Promise((resolve, reject) => {
      this.adapter
        .request(url, data, config, () => {
          this.stateService.setIsLoggedIn(false)
        })
        .then(
          (res: any) => {
            if (res.login === false) {
              this.stateService.setIsLoggedIn(false)
              this.stateService.username.next('')
              reject(false)
            }

            if (
              this.stateService.username.getValue().length < 1 &&
              res.MF_GETUSER
            ) {
              this.stateService.username.next(res.MF_GETUSER)
            }

            if (res.status === 404) {
              reject({ MESSAGE: res.body || 'SAS responded with an error' })
            }

            resolve(res)
          },
          (err: any) => {
            reject(err)
          }
        )
    })
  }
  public request(url: string, data: any, config?: any) {
    url = 'services/' + url

    return new Promise((resolve, reject) => {
      this.adapter
        .request(url, data, config, () => {
          this.stateService.setIsLoggedIn(false)
        })
        .then(
          (res: any) => {
            if (res.login === false) {
              this.stateService.setIsLoggedIn(false)
              this.stateService.username.next('')
              reject(false)
            }

            if (
              this.stateService.username.getValue().length < 1 &&
              res.MF_GETUSER
            ) {
              this.stateService.username.next(res.MF_GETUSER)
            }

            if (res.status === 404) {
              reject({ MESSAGE: res.body || 'SAS responded with an error' })
            }

            resolve(res)
          },
          (err: any) => {
            reject(err)
          }
        )
    })
  }

  public ejecutarReProceso(url: string,id_proceso: string, config?: any): Promise<any>{
    url = 'services/' + url
    const data: { [key: string]: Array<{ [key: string]: any }> } = {
      'reRunTable': []
    };

    const reRunData: { [key: string]: any } = {

      'id_proceso': id_proceso   
    };
    data['reRunTable'].push(reRunData);

    return new Promise((resolve, reject) => {
      this.adapter
        .request(url, data, config, () => {
          this.stateService.setIsLoggedIn(false)
        })
        .then(
          (res: any) => {
            if (res.login === false) {
              this.stateService.setIsLoggedIn(false)
              this.stateService.username.next('')
              reject(false)
            }

            if (
              this.stateService.username.getValue().length < 1 &&
              res.MF_GETUSER
            ) {
              this.stateService.username.next(res.MF_GETUSER)
            }

            if (res.status === 404) {
              reject({ MESSAGE: res.body || 'SAS responded with an error' })
            }

            resolve(res)
          },
          (err: any) => {
            reject(err)
          }
        )
    })
  }
  public actualizarRegla(url: string, regla: { nombreProc: string; nombreRegla: string; nuevoEstado: number }, config?: any): Promise<any>{
    url = 'services/' + url
    const data: { [key: string]: Array<{ [key: string]: any }> } = {
      'reglaTable': []
    };

    const reglaData: { [key: string]: any } = {

      'NombreProceso': regla.nombreProc,   
      'NombreRegla': regla.nombreRegla,    
      'NuevoEstado': regla.nuevoEstado     
    };
    data['reglaTable'].push(reglaData);

    return new Promise((resolve, reject) => {
      this.adapter
        .request(url, data, config, () => {
          this.stateService.setIsLoggedIn(false)
        })
        .then(
          (res: any) => {
            if (res.login === false) {
              this.stateService.setIsLoggedIn(false)
              this.stateService.username.next('')
              reject(false)
            }

            if (
              this.stateService.username.getValue().length < 1 &&
              res.MF_GETUSER
            ) {
              this.stateService.username.next(res.MF_GETUSER)
            }

            if (res.status === 404) {
              reject({ MESSAGE: res.body || 'SAS responded with an error' })
            }

            resolve(res)
          },
          (err: any) => {
            reject(err)
          }
        )
    })
  }

  public async login(username: string, password: string) {
    return this.adapter
      .logIn(username, password)
      .then(
        (res: { isLoggedIn: boolean; userName: string }) => {
          console.log(res)
          this.stateService.setIsLoggedIn(res.isLoggedIn)

          this.stateService.username.next(res.userName)

          return res.isLoggedIn
        },
        (err: any) => {
          console.error(err)
          this.stateService.setIsLoggedIn(false)
          return false
        }
      )
      .catch((e: any) => {
        if (e === 403) {
          console.error('Invalid host')
        }
        return false
      })
  }

  public uploadFile(sasService: string, files: UploadFile[], params?: any) {
    
    return this.adapter.uploadFile(sasService, files, params)
  }

  public logout() {
    this.adapter.logOut().then(() => {
      this.stateService.setIsLoggedIn(false)
      this.stateService.username.next('')
    })
  }

  public getSasjsConfig() {
    return this.adapter.getSasjsConfig()
  }

  public getSasRequests() {
    return this.adapter.getSasRequests()
  }

  public setDebugState(state: boolean) {
    this.adapter.setDebugState(state)
  }


  public download(url: string): Observable<HttpResponse<Blob>> {
    return this.http.get(url, {
      observe: 'response',
      responseType: 'blob'
    });
  }


  public postAtributos(url: string, field: any, config?: any) {
    return new Promise((resolve, reject) => {
      this.adapter
        .request(url, field, config, () => {
          this.stateService.setIsLoggedIn(false)
        })
        .then(
          (res: any) => {
            if (res.login === false) {
              this.stateService.setIsLoggedIn(false)
              this.stateService.username.next('')
              reject(false)
            }

            if (
              this.stateService.username.getValue().length < 1 &&
              res.MF_GETUSER
            ) {
              this.stateService.username.next(res.MF_GETUSER)
            }

            if (res.status === 404) {
              reject({ MESSAGE: res.body || 'SAS responded with an error' })
            }

            resolve(res)
          },
          (err: any) => {
            reject(err)
          }
        )
    })
  }

  

}
