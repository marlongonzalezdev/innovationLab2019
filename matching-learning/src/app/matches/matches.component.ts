import { Component, OnInit } from '@angular/core';
import { Users } from '../mock-users';
import { User } from '../user';
@Component({
  selector: 'app-matches',
  templateUrl: './matches.component.html',
  styleUrls: ['./matches.component.css']
})
export class MatchesComponent implements OnInit {
  users = Users;

  selectedUser: User;
  
  onSelect(user: User): void {
    this.selectedUser = user;
  }
  constructor() { }

  ngOnInit() {
  }

}
