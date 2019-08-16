import { Skills } from './../../models/skills';
import {Component, Input, OnInit, ViewChild} from '@angular/core';
import { SkillServiceBase } from './services/skill-servie-base';
import {MatPaginator} from '@angular/material/paginator';
import {MatTableDataSource} from '@angular/material/table';

@Component({
    selector: 'app-skills',
    templateUrl: './skills.component.html',
    styleUrls: ['./skills.component.css']
})
export class SkillsComponent implements OnInit {
    skillList: Skills[];
    displayedColumns: ['name', 'category', 'defaultExpertise', 'code'];
    selectedSkill: Skills;
    showContent: boolean;
    source: any;

    constructor(private skillService: SkillServiceBase) {
    }

    @ViewChild(MatPaginator, {static: true}) paginator: MatPaginator;
    ngOnInit() {
      this.skillService.getSkill()
      .subscribe ( skills => {
         this.skillList = skills;
         this.source = new MatTableDataSource<Skills>(this.skillList);
         this.source.paginator = this.paginator;
      });
    }


}
