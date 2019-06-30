import { Component, OnInit } from '@angular/core';
import { User } from '../user';
import { MatchService } from '../match.service';
import { Match } from '../match';
import { Project } from '../project';
import { Skill } from '../skill';
@Component({
  selector: 'app-matches',
  templateUrl: './matches.component.html',
  styleUrls: ['./matches.component.css']
})
export class MatchesComponent implements OnInit {
  users: User[];

  selectedUser: User;
  matches: Match[];
  
  onSelect(user: User): void {
    this.selectedUser = user;
  }
  constructor(private matchService: MatchService) { }

  ngOnInit() {

    //project dummy initialization
    let skills: Skill[] = [
      new Skill("angular", 0.6),
      new Skill("c#", 0.6),
      new Skill("kotlin", 0.6),
    ]
    let project: Project = {
      name: "test",
      skills: skills
    };

    this.getUsers(project);
  }

  getUsers(project: Project): void {

    this.matchService.getMatches(project)
      .subscribe(matches => this.matches = matches);
  }
}
