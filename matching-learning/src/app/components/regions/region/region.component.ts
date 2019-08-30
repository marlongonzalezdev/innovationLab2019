import {Component, OnInit} from '@angular/core';
import {RegionService} from '../../../shared/services/region.service';
import {MatDialogRef} from '@angular/material';
import {Region} from '../../../shared/models/region';
import {NotificationService} from '../../../shared/services/notification.service';

@Component({
    selector: 'app-region',
    templateUrl: './region.component.html',
    styleUrls: ['./region.component.css']
})
export class RegionComponent implements OnInit {

    constructor(private service: RegionService,
                public dialogRef: MatDialogRef<RegionComponent>,
                private notificationService: NotificationService) {
    }

    ngOnInit() {
    }

    onClear() {
        this.service.form.reset();
        this.service.InitializeFormGroup();
    }

    onSubmit() {
        if (this.service.form.valid) {
            const region: Region = {
                id: -1,
                name: '',
                code: ''
            };

            this.service.addRegion(region).subscribe(
                elem => {
                    this.notificationService.sucess('Region saved successfully.');
                    this.onClear();
                    console.log(elem);
                    this.onClose();
                }
            );
        }
    }

    onClose() {
        this.onClear();
        this.dialogRef.close();
    }

}
