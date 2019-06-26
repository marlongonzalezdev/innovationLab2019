import { Component, OnInit } from '@angular/core';
import { User } from '../user';
import { MatchService } from '../match.service';
@Component({
  selector: 'app-matches',
  templateUrl: './matches.component.html',
  styleUrls: ['./matches.component.css']
})
export class MatchesComponent implements OnInit {
  users: User[];

  selectedUser: User;

  onSelect(user: User): void {
    this.selectedUser = user;
  }
  constructor(private matchService: MatchService) { }

  getUsers(): void {
    this.matchService.getMatches()
      .subscribe(users => this.users = users);
  }

  ngOnInit() {
    this.getUsers();
  }
}
