import {Component, Input, OnDestroy, OnInit, ViewChild} from '@angular/core';
import {ActivatedRoute} from '@angular/router';
import {EvaluationService} from '../../../shared/services/evaluation.service';
import {Evaluation} from '../../../shared/models/evaluation';
import {MatDialog, MatDialogConfig, MatPaginator, MatSort, MatTableDataSource} from '@angular/material';
import {Candidate} from '../../../shared/models/candidate';
import {CandidateComponent} from '../../candidates/candidate/candidate.component';
import {EvaluationComponent} from '../evaluation/evaluation.component';

@Component({
  selector: 'app-evaluation-list',
  templateUrl: './evaluation-list.component.html',
  styleUrls: ['./evaluation-list.component.css']
})
export class EvaluationListComponent implements OnInit, OnDestroy {
  id: number;
  private sub: any;
  candidate: Candidate;

  dataSource: any;
  displayedColumns: string[] = ['evaluationType', 'date', 'notes', 'actions'];
  searchKey: string;
  @ViewChild(MatSort, {static: false}) sort: MatSort;
  @ViewChild(MatPaginator, {static: false}) paginator: MatPaginator;

  constructor(private route: ActivatedRoute, private  evaluationService: EvaluationService, private dialog: MatDialog) {}

  ngOnInit() {
    this.fillDataSource();
  }

  ngOnDestroy() {
    this.sub.unsubscribe();
  }

  onEdit(row: any) {
  }

  onCreate(candidate: Candidate) {
    this.evaluationService.InitializeFormGroup();
    this.openDialog(candidate);
  }

  applyFilter() {
    this.dataSource.filter = this.searchKey.trim().toLowerCase();
  }

  onSearchClear() {
    this.searchKey = '';
    this.applyFilter();
  }

  openDialog(selectedCandidate) {
    const dialogConfig = new MatDialogConfig();
    dialogConfig.disableClose = true;
    dialogConfig.autoFocus = true;
    dialogConfig.width = '40%';
    dialogConfig.data = {
       id: selectedCandidate.id
    };
    const dialogRef = this.dialog.open(EvaluationComponent, dialogConfig);

    dialogRef.afterClosed().subscribe(result => {
      console.log('The dialog was closed');
      this.fillDataSource();
    });
  }

   fillDataSource() {
    this.sub = this.route.params.subscribe(params => {
      this.id = +params.id; // (+) converts string 'id' to a number
      this.evaluationService.getEvaluations(this.id)
        .subscribe(response => {
          this.candidate = response;
          this.dataSource = new MatTableDataSource<Evaluation>(this.candidate.evaluations);
          this.dataSource.sort = this.sort;
          this.dataSource.paginator = this.paginator;
        });
    });
  }

  getToolTipData(element: any): string {
    return element.notes;
  }
}
