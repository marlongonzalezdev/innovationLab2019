import {Component, OnInit, ViewChild} from '@angular/core';
import {MatDialog, MatPaginator, MatSort, MatTableDataSource} from '@angular/material';
import {DeliveryUnit} from '../../../shared/models/deliveryUnit';
import {DeliveryUnitService} from '../../../shared/services/delivery-unit.service';
import {Region} from '../../../shared/models/region';

@Component({
    selector: 'app-delivery-units-list',
    templateUrl: './delivery-unit-list.component.html',
    styleUrls: ['./delivery-unit-list.component.css']
})
export class DeliveryUnitListComponent implements OnInit {

    deliveryUnits: DeliveryUnit[] = [];
    dataSource: any;
    displayedColumns: string[] = ['name', 'code', 'region', 'actions'];
    searchKey: string;
    @ViewChild(MatSort, {static: false}) sort: MatSort;
    @ViewChild(MatPaginator, {static: false}) paginator: MatPaginator;

    constructor(private deliveryUnitService: DeliveryUnitService, private dialog: MatDialog) {
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
        this.deliveryUnitService.getDeliveryUnits()
            .subscribe(response => {
                this.deliveryUnits = response;
                this.dataSource = new MatTableDataSource<Region>(this.deliveryUnits);
                this.dataSource.sort = this.sort;
                this.dataSource.paginator = this.paginator;
            });
    }
}
