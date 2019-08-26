import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';

import { DeliveryUnit } from '../models/deliveryUnit';
import { environment } from 'src/environments/environment';

@Injectable({
  providedIn: 'root'
})
export class DeliveryUnitService {

  constructor(private httpClient: HttpClient) { }

  getDeliveryUnits() {
    return this.httpClient.get<DeliveryUnit[]>(environment.dbConfig.baseUrl + environment.dbConfig.GetDeliveryUnits);
  }
  
  getDefaultDeliveryUnit() {
    return this.httpClient.get<DeliveryUnit>(environment.dbConfig.baseUrl + environment.dbConfig.GetDefaultDeliveryUnit);
  }
}


