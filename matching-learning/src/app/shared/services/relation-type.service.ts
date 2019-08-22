import { Injectable } from '@angular/core';

import { HttpClient } from '@angular/common/http';
import { RelationType } from '../models/relationType';
import { environment } from 'src/environments/environment';

@Injectable({
  providedIn: 'root'
})
export class RelationTypeService {


  constructor(private httpClient: HttpClient) { }

  getRelationTypes() {
    return this.httpClient.get<RelationType[]>(environment.dbConfig.baseUrl + environment.dbConfig.GetRelationTypes);
  }
}
