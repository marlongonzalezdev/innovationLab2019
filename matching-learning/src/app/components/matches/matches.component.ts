import {Component, OnInit, Input, ViewChild} from '@angular/core';
import {MatPaginator} from '@angular/material/paginator';
import {MatTableDataSource} from '@angular/material/table';

import { Match } from 'src/app/shared/models/match';
import { Project } from 'src/app/shared/models/project';
import { MatchService } from 'src/app/match.service';


@Component({
    selector: 'app-matches',
    templateUrl: './matches.component.html',
    styleUrls: ['./matches.component.css']
})
export class MatchesComponent implements OnInit {

    displayedColumns: string[] = ['userName', 'matchingScore'];
    dataSource: any;
    @ViewChild(MatPaginator, {static: true}) paginator: MatPaginator;

    matches: Match[] = [];
    selectedMatch: Match;

    loading: boolean;

    @Input() project: Project;
    @Input() display: boolean;
    @Input() showContent: boolean;

    processData() {
        this.showContent = false;
        this.loading = true;
        this.getUsers(this.project);
    }

    onSelect(match: Match): void {
        this.selectedMatch = match;
    }

    constructor(private matchService: MatchService) {
    }

    ngOnInit() {
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
