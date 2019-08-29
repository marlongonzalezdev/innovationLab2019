import { LoginData } from './../../shared/models/loginData';
import { Component, OnInit } from '@angular/core';
import { LoginService } from '../../shared/services/login.service';
import { Router, ActivatedRoute } from '@angular/router';


@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {

  constructor(public loginService: LoginService, private route: ActivatedRoute,
              private router: Router) { }

  ngOnInit() {
  }

  onSubmit(loginData){
     const credentials: LoginData = {
       userName: loginData.user,
       password: loginData.password,
       authenticated: null,
       message: null
     };
     this.loginService.getUserAuthenticated(credentials)
     .subscribe(response => {
       if (response.authenticated) {
         this.router.navigate(['/build']);
       } else {
         this.router.navigate(['/']);
       }
     });
  }

}
