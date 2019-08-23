import {Region} from './region';

export interface DeliveryUnit {
  id: number;
  code: string;
  name: string;
  regionId: number;
  region: Region;
}


