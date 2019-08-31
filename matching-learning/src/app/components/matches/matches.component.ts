import {Component, OnInit, Input, ViewChild} from '@angular/core';
import {MatPaginator} from '@angular/material/paginator';
import {MatTableDataSource} from '@angular/material/table';

import { Match } from 'src/app/shared/models/match';
import { Project } from 'src/app/shared/models/project';
import { MatchService } from 'src/app/shared/services/match.service';
import {MatDialog, MatDialogConfig} from '@angular/material';
import {UserDetailsComponent} from '../user-details/user-details.component';


@Component({
    selector: 'app-matches',
    templateUrl: './matches.component.html',
    styleUrls: ['./matches.component.css']
})
export class MatchesComponent implements OnInit {

    displayedColumns: string[] = ['userName', 'picture', 'deliveryUnit', 'role', 'grade', 'projectName', 'projectSince', 'matchingScore'];
    dataSource: any;
    @ViewChild(MatPaginator, {static: false}) paginator: MatPaginator;

    matches: Match[] = [];
    selectedMatch: Match;

    loading: boolean;

    @Input() project: Project;
    @Input() display: boolean;
    showContent = false;

    processData() {
      /*  this.showContent = false;*/
        this.loading = true;
        this.getUsers(this.project);
    }

 /*   onSelect(match: Match): void {
        this.selectedMatch = match;
    }
*/
    constructor(private matchService: MatchService, private dialog: MatDialog) {
    }

    ngOnInit() {
    }

  openDialog(match: Match) {

    const dialogConfig = new MatDialogConfig();

    dialogConfig.autoFocus = true;
    dialogConfig.width = '50%';
    dialogConfig.data = {
      name: match.candidate.name,
      picture: match.candidate.picture,
      deliveryUnit: match.candidate.deliveryUnit.name,
      role: match.candidate.activeRole.name,
      relationType: match.candidate.relationType,
      inBench: match.candidate.inBench,
      ranking: match.ranking,
      docType: match.candidate.docType,
      docNumber: match.candidate.docNumber,
      employeeNumber: match.candidate.employeeNumber,
	  gradeDescription: match.candidate.gradeDescription,
	  currentProjectDescription: match.candidate.currentProjectDescription,
	  currentProjectDuration: match.candidate.currentProjectDuration,
      skillExpertisesSummary: match.skillExpertisesSummary
    };

    const dialogRef = this.dialog.open(UserDetailsComponent, dialogConfig);

    dialogRef.afterClosed().subscribe(result => {
      console.log('The dialog was closed');
     /* this.animal = result;*/
    });
  }

    getUsers(project: Project): void {

        this.matchService.getMatches(project)
            .subscribe(response => {
                this.matches = response;
                this.dataSource = new MatTableDataSource<Match>(this.matches);
                this.dataSource.paginator = this.paginator;
                this.loading = false;
                this.showContent = true;
            });
    }
}
