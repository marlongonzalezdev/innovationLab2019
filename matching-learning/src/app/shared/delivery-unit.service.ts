import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import {environment} from '../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class DeliveryUnitService {

  private deliveryUnits  = [];

  constructor(private httpClient: HttpClient) { }

  getDeliveryUnits(): any[] {
    this.httpClient.get(environment.dbConfig.baseUrl + environment.dbConfig.GetDeliveryUnits).subscribe((res: any[]) => {
      console.log(res);
      this.deliveryUnits = res;
    });
    return this.deliveryUnits;
  }

}


