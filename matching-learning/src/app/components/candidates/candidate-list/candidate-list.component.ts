import {Component, OnInit, ViewChild} from '@angular/core';
import {CandidateService} from 'src/app/shared/services/candidate.service';
import {Candidate} from 'src/app/shared/models/candidate';
import {MatDialog, MatDialogConfig, MatPaginator, MatSort, MatTableDataSource} from '@angular/material';
import {CandidateComponent} from '../candidate/candidate.component';

@Component({
  selector: 'app-candidate-list',
  templateUrl: './candidate-list.component.html',
  styleUrls: ['./candidate-list.component.css']
})
export class CandidateListComponent implements OnInit {

  candidates: Candidate[] = [];
  dataSource: any;
  displayedColumns: string[] = ['name', 'picture', 'deliveryUnit', 'activeRole', 'inBench', 'isActive', 'actions'];
  searchKey: string;
  @ViewChild(MatSort, {static: false}) sort: MatSort;
  @ViewChild(MatPaginator, {static: false}) paginator: MatPaginator;

  constructor(private candidateService: CandidateService, private dialog: MatDialog) {
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
    this.candidateService.getCandidates()
      .subscribe(response => {
        this.candidates = response;
        this.dataSource = new MatTableDataSource<Candidate>(this.candidates);
        this.dataSource.sort = this.sort;
        this.dataSource.paginator = this.paginator;
      });
  }

  onCreate() {
    this.candidateService.InitializeFormGroup();
    this.openDialog();
  }

  onEdit(row) {
    this.candidateService.populateForm(row);
    this.openDialog();
  }

  openDialog() {
    const dialogConfig = new MatDialogConfig();
    dialogConfig.disableClose = true;
    dialogConfig.autoFocus = true;
    dialogConfig.width = '40%';
    const dialogRef = this.dialog.open(CandidateComponent, dialogConfig);

    dialogRef.afterClosed().subscribe(result => {
      console.log('The dialog was closed');
      this.fillDataSource();
    });
  }
}
