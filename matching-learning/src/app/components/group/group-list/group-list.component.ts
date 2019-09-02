import {Component, OnInit, ViewChild} from '@angular/core';
import {MatDialog, MatDialogConfig, MatPaginator, MatSort} from '@angular/material';
import {Match} from '../../../shared/models/match';
import {UserDetailsComponent} from '../../user-details/user-details.component';

@Component({
  selector: 'app-group-list',
  templateUrl: './group-list.component.html',
  styleUrls: ['./group-list.component.css']
})
export class GroupListComponent implements OnInit {

  dataSource: any;
  displayedColumns: string[] = ['name', 'picture', 'deliveryUnit', 'candidateRole', 'grade', 'projectName', 'projectSince', 'actions'];
  searchKey: string;
  @ViewChild(MatSort, {static: false}) sort: MatSort;
  @ViewChild(MatPaginator, {static: false}) paginator: MatPaginator;

  constructor(private dialog: MatDialog) {
  }

  onSearchClear() {
    this.searchKey = '';
    this.applyFilter();
  }

  applyFilter() {
    this.dataSource.filter = this.searchKey.trim().toLowerCase();
  }

  ngOnInit() {
    this.fillDataSource();
  }

  fillDataSource() {
    const storage = localStorage.getItem('group');
    const group = storage ? JSON.parse(storage) : [];
    this.dataSource = group;
  }

  delete(element) {
    const storage = localStorage.getItem('group');
    let group = storage ? JSON.parse(storage) : [];
    group = group.filter((e) => {
      return element.candidate.id !== e.candidate.id;
    });
    this.dataSource = group;
    localStorage.setItem('group', JSON.stringify(group));
  }

  openDialog(match: Match) {

    const dialogConfig = new MatDialogConfig();

    dialogConfig.autoFocus = true;
    dialogConfig.width = '50%';
    dialogConfig.data = {
      name: match.candidate.name,
      picture: match.candidate.picture,
      deliveryUnit: match.candidate.deliveryUnit.name,
      role: match.candidate.candidateRole.name,
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

}
