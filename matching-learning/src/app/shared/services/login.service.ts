import { Injectable } from '@angular/core';
import { FormGroup, FormControl, Validators } from '@angular/forms';

@Injectable({
  providedIn: 'root'
})
export class LoginService {

  constructor() { }

  loginForm = new FormGroup ({
    user: new FormControl('', Validators.required),
    password: new FormControl('', Validators.required)
  });
}
