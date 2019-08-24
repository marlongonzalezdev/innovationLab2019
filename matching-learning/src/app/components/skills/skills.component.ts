import { MatTableDataSource } from '@angular/material/table';
import { Skill } from '../../shared/models/skill';
import {Component, Input, OnInit, ViewChild} from '@angular/core';

import {MatPaginator} from '@angular/material/paginator';
import { MatSort } from '@angular/material/sort';
import { SkilldetailsComponent } from '../skilldetails/skilldetails.component';
import {SkillServiceBase} from '../../shared/services/skill-service-base';

@Component({
    selector: 'app-skills',
    templateUrl: './skills.component.html',
    styleUrls: ['./skills.component.css']
})
export class SkillsComponent implements OnInit {
    skillList: Skill[] = [];
    displayedColumns = ['name', 'category', 'editAction'];
    selectedSkill: Skill;
    showContent: boolean;
    source: MatTableDataSource<Skill>;
    @ViewChild(MatPaginator, {static: true}) paginator: MatPaginator;
    @ViewChild(MatSort, {static: true}) sort: MatSort;
    constructor(private skillService: SkillServiceBase) {
    }

    ngOnInit() {
      this.showContent = false;
      this.skillService.getSkills()
      .subscribe ( response => {
         this.skillList = response;
        //  this.source = new MatTableDataSource<Skills>(this.skillList);
         /* this.source.paginator = this.paginator;
         this.source.sort = this.sort; */
      });
    }
    applyFilter(filterValue: string) {
      this.source.filter = filterValue.trim().toLowerCase();

      if (this.source.paginator) {
        this.source.paginator.firstPage();
      }
    }
      protected addDevice(): void {
       this.selectedSkill = null;
       this.showContent = true;
    }

    onChangedShowContent(displayContent: boolean) {
      this.showContent = displayContent;
    }
}
