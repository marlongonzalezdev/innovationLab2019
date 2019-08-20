import { Injectable } from '@angular/core';
import {FormControl, FormGroup, Validators} from '@angular/forms';

@Injectable({
  providedIn: 'root'
})
export class CandidateService {

  constructor() { }

  form: FormGroup = new FormGroup({
    $key: new FormControl(null),
    name: new FormControl('', Validators.required),
    lastName: new FormControl('', Validators.required),
    du: new FormControl(0),
    relationType: new FormControl(0),
    email: new FormControl('', Validators.email),
    gender: new FormControl(0),
    isInternal: new FormControl(false),
    isInBench: new FormControl(false)
  });

  InitializeFormGroup() {
    this.form.setValue({
      $key: null,
      name: '',
      lastName: '',
      du: 0,
      relationType: 0,
      email: '',
      gender: 0,
      isInternal: false,
      isInBench: false
    });
  }
}
