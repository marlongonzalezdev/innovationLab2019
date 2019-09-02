import {Component, OnInit, ViewChild} from '@angular/core';
import {CandidateService} from 'src/app/shared/services/candidate.service';
import {Candidate} from 'src/app/shared/models/candidate';
import {MatDialog, MatDialogConfig, MatPaginator, MatSort, MatTableDataSource} from '@angular/material';

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

  constructor() {
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
    console.log(group);
    this.dataSource = group;
  }

  delete(element) {
    const storage = localStorage.getItem('group');
    let group = storage ? JSON.parse(storage) : [];
    console.log(group);
    group = group.filter((e) => {
      return element.candidate.id !== e.candidate.id;
    });
    console.log(group);
    this.dataSource = group;
    localStorage.setItem('group', JSON.stringify(group));
  }

}
