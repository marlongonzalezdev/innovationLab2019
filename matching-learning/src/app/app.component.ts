import { LoginService } from 'src/app/shared/services/login.service';
import { LoginData } from './shared/models/loginData';

import {Component, OnInit} from '@angular/core';
import { Router } from '@angular/router';


@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {
  title = 'matching-learning';
  currentUser: LoginData;

  constructor(
      private router: Router,
      private authenticationService: LoginService
  ) {
      this.authenticationService.currentUser.subscribe(x => this.currentUser = x);
  }

  logout() {
      this.authenticationService.logout();
      this.router.navigate(['/login']);
  }
  ngOnInit(): void {
  }
}
