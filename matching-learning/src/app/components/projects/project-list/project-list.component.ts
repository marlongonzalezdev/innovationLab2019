import {Component, OnInit, ViewChild} from '@angular/core';
import {Project} from '../../../shared/models/project';
import {ProjectService} from '../../../shared/services/project.service';
import {MatDialog, MatDialogConfig, MatPaginator, MatSort, MatTableDataSource} from '@angular/material';
import {ProjectComponent} from '../project/project.component';

@Component({
    selector: 'app-project-list',
    templateUrl: './project-list.component.html',
    styleUrls: ['./project-list.component.css']
})
export class ProjectListComponent implements OnInit {

    projects: Project[] = [];
    dataSource: any;
    displayedColumns: string[] = ['name', 'code', 'actions'];
    searchKey: string;
    @ViewChild(MatSort, {static: false}) sort: MatSort;
    @ViewChild(MatPaginator, {static: false}) paginator: MatPaginator;

    constructor(private projectService: ProjectService, private dialog: MatDialog) {
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
        this.projectService.getProjects()
            .subscribe(response => {
                this.projects = response;
                this.dataSource = new MatTableDataSource<Project>(this.projects);
                this.dataSource.sort = this.sort;
                this.dataSource.paginator = this.paginator;
            });
    }

    onCreate() {
        this.projectService.InitializeFormGroup();
        this.openDialog();
    }

    onEdit(row) {
        this.projectService.populateForm(row);
        this.openDialog();
    }

    openDialog() {
        const dialogConfig = new MatDialogConfig();
        dialogConfig.disableClose = true;
        dialogConfig.autoFocus = true;
        dialogConfig.width = '40%';
        const dialogRef = this.dialog.open(ProjectComponent, dialogConfig);

        dialogRef.afterClosed().subscribe(result => {
            console.log('The dialog was closed');
            this.fillDataSource();
        });
    }
}
