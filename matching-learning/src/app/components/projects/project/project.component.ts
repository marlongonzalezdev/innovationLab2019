import {Component, OnInit} from '@angular/core';
import {ProjectService} from '../../../shared/services/project.service';
import {MatDialogRef} from '@angular/material';
import {Project} from '../../../shared/models/project';
import {NotificationService} from '../../../shared/services/notification.service';

@Component({
    selector: 'app-project',
    templateUrl: './project.component.html',
    styleUrls: ['./project.component.css']
})
export class ProjectComponent implements OnInit {

    constructor(private service: ProjectService,
                public dialogRef: MatDialogRef<ProjectComponent>,
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
            const project: Project = {
                id: -1,
                name: '',
                code: ''
            };

            this.service.addProject(project).subscribe(
                elem => {
                    this.notificationService.sucess('Project saved successfully.');
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
