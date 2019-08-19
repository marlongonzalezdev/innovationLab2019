import { Injectable } from '@angular/core';
import {environment} from '../../environments/environment';
import { HttpClient } from '@angular/common/http';

@Injectable({
  providedIn: 'root'
})
export class RelationTypeService {

  private relationTypes  = [];
  constructor(private httpClient: HttpClient) { }

  getRelationTpes(): any[] {
    this.httpClient.get(environment.dbConfig.baseUrl + environment.dbConfig.GetRelationTypes).subscribe((res: any[]) => {
      console.log(res);
      this.relationTypes = res;
    });
    return this.relationTypes;
  }
}
