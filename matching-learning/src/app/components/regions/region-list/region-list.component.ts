import {Component, OnInit, ViewChild} from '@angular/core';
import {Region} from '../../../shared/models/region';
import {RegionService} from '../../../shared/services/region.service';
import {MatDialog, MatDialogConfig, MatPaginator, MatSort, MatTableDataSource} from '@angular/material';
import {RegionComponent} from '../region/region.component';

@Component({
    selector: 'app-region-list',
    templateUrl: './region-list.component.html',
    styleUrls: ['./region-list.component.css']
})
export class RegionListComponent implements OnInit {

    regions: Region[] = [];
    dataSource: any;
    displayedColumns: string[] = ['name', 'code', 'actions'];
    searchKey: string;
    @ViewChild(MatSort, {static: false}) sort: MatSort;
    @ViewChild(MatPaginator, {static: false}) paginator: MatPaginator;

    constructor(private regionService: RegionService, private dialog: MatDialog) {
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
        this.regionService.getRegions()
            .subscribe(response => {
                this.regions = response;
                this.dataSource = new MatTableDataSource<Region>(this.regions);
                this.dataSource.sort = this.sort;
                this.dataSource.paginator = this.paginator;
            });
    }

    onCreate() {
        this.regionService.InitializeFormGroup();
        this.openDialog();
    }

    onEdit(row) {
        this.regionService.populateForm(row);
        this.openDialog();
    }

    openDialog() {
        const dialogConfig = new MatDialogConfig();
        dialogConfig.disableClose = true;
        dialogConfig.autoFocus = true;
        dialogConfig.width = '40%';
        const dialogRef = this.dialog.open(RegionComponent, dialogConfig);

        dialogRef.afterClosed().subscribe(result => {
            console.log('The dialog was closed');
            this.fillDataSource();
        });
    }
}
