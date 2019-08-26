import { SaveResult } from './../../shared/models/saveResult';
import { MatTableDataSource } from '@angular/material/table';
import { Skill } from '../../shared/models/skill';
import {Component, Input, OnInit, ViewChild} from '@angular/core';

import {MatPaginator} from '@angular/material/paginator';
import { MatSort } from '@angular/material/sort';
import { SkilldetailsComponent } from '../skilldetails/skilldetails.component';
import {SkillServiceBase} from '../../shared/services/skill-service-base';
import { NotificationService } from '../../shared/services/notification.service';
import { MatDialogConfig, MatDialog } from '@angular/material/dialog';

@Component({
    selector: 'app-skills',
    templateUrl: './skills.component.html',
    styleUrls: ['./skills.component.css']
})
export class SkillsComponent implements OnInit {
    skillList: Skill[] = [];
    displayedColumns = ['name', 'category', 'actions'];
    selectedSkill: Skill;
    showContent: boolean;
    source: MatTableDataSource<Skill>;
    searchKey: string;
    skillCategories: any;
    @ViewChild(MatSort, {static: false}) sort: MatSort;
    @ViewChild(MatPaginator, {static: false}) paginator: MatPaginator;
    constructor(private skillService: SkillServiceBase,
                private notificationService: NotificationService, private dialog: MatDialog) {
    }

    ngOnInit() {
      this.showContent = false;
      this.skillService.getSkills()
      .subscribe ( response => {
         this.skillList = response;
         this.source = new MatTableDataSource<Skill>(this.skillList);
         this.source.sort = this.sort;
         this.source.paginator = this.paginator;
      });
      this.skillService.getSkillCategory()
      .subscribe(response => {
      this.skillCategories = response;
    }
      );
    }
    findCategoryName(categoryId: number) {
      const category = this.skillCategories.find((c: { id: number; }) => {
        return c.id === categoryId;
      });
      return category.name;
    }
    onSearchClear() {
      this.searchKey = '';
      this.applyFilter();
    }
    applyFilter() {
      this.source.filter = this.searchKey.trim().toLowerCase();
    }
    addSkill(): void {
       this.skillService.initializeFormGroup();
       const dialogConfig = new MatDialogConfig();
       dialogConfig.disableClose = true;
       dialogConfig.autoFocus = true;
       dialogConfig.width = '40%';
       this.dialog.open(SkilldetailsComponent, dialogConfig);
    }

    onChangedShowContent(displayContent: boolean) {
      this.showContent = displayContent;
    }

    onSaveSkillComplete(result: SaveResult) {
      if (result.recordId) {
         this.notificationService.sucess('Skill saved successfully');
      } else {
         this.notificationService.fail(result.error);
      }
    }
    onEdit(row) {
      this.skillService.populateForm(row);
      const dialogConfig = new MatDialogConfig();
      dialogConfig.disableClose = true;
      dialogConfig.autoFocus = true;
      dialogConfig.width = '40%';
      this.dialog.open(SkilldetailsComponent, dialogConfig);
    }
}
