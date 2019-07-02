import { Component, OnInit, Input } from '@angular/core';
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
   
  matches: Match[];
  selectedMatch: Match;
  
  loading: boolean;
  showContent: boolean;

  @Input() project: Project

  processData() {
    this.showContent = false;
    this.loading = true;    
    this.getUsers(this.project);  
  }

  onSelect(match: Match): void {
    this.selectedMatch = match;
  }
  constructor(private matchService: MatchService) { }

  ngOnInit() {

  }

  getUsers(project: Project): void {

    this.matchService.getMatches(project)
      .subscribe(response => 
        {
          this.matches = response.matches; 
          this.loading = false;
          this.showContent = true;
        });
  }
}
