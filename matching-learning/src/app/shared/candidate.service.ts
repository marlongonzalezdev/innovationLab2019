import { Injectable } from '@angular/core';
import {FormControl, FormGroup} from '@angular/forms';

@Injectable({
  providedIn: 'root'
})
export class CandidateService {

  constructor() { }

  form: FormGroup = new FormGroup({
    $key: new FormControl(null),
    fullName: new FormControl(''),
    email: new FormControl(''),
    gender: new FormControl(0),
    isInternal: new FormControl(false),
    isInBench: new FormControl(false),
    du: new FormControl(0)
  });
}
