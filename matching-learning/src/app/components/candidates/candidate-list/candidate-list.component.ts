import {Component, OnInit, ViewChild} from '@angular/core';
import {CandidateService} from 'src/app/shared/services/candidate.service';
import {Candidate} from 'src/app/shared/models/candidate';
import {MatPaginator, MatSort, MatTableDataSource} from '@angular/material';

@Component({
  selector: 'app-candidate-list',
  templateUrl: './candidate-list.component.html',
  styleUrls: ['./candidate-list.component.css']
})
export class CandidateListComponent implements OnInit {

  candidates: Candidate[] = [];
  dataSource: any;
  displayedColumns: string[] = ['name', 'deliveryUnit', 'activeRole', 'inBench', 'actions'];
  searchKey: string;
  @ViewChild(MatSort, {static: true}) sort: MatSort;
  @ViewChild(MatPaginator, {static: true}) paginator: MatPaginator;

  constructor(private candidateService: CandidateService) {
  }

  onSearchClear() {
    this.searchKey = '';
    this.applyFilter();
  }

  applyFilter() {
    this.dataSource.filter = this.searchKey.trim().toLowerCase();
  }

  ngOnInit() {

    this.candidateService.getCandidates()
      .subscribe(response => {
        this.candidates = response;
        this.dataSource = new MatTableDataSource<Candidate>(this.candidates);
        this.dataSource.sort = this.sort;
        this.dataSource.paginator = this.paginator;
      });
  }
}
