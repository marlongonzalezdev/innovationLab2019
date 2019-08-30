import { Component, OnInit } from '@angular/core';
import { LoginService } from 'src/app/shared/services/login.service';
import { LoginData } from 'src/app/shared/models/loginData';
import { Router } from '@angular/router';

@Component({
  selector: 'app-menu',
  templateUrl: './menu.component.html',
  styleUrls: ['./menu.component.css']
})
export class MenuComponent implements OnInit {
  currentUser: LoginData;
  constructor(private authenticationService: LoginService, private router: Router) {
    this.authenticationService.currentUser.subscribe(x => this.currentUser = x); }

  ngOnInit() {
  }
  Logout() {
    this.authenticationService.logout();
    this.router.navigate(['/login']);
  }

}
