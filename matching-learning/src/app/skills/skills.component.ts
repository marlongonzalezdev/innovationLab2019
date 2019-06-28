import { Component, OnInit } from '@angular/core';


export interface Skill {
  value: string;
  viewValue: string;
}


@Component({
  selector: 'app-skills',
  templateUrl: './skills.component.html',
  styleUrls: ['./skills.component.css']
})
export class SkillsComponent implements OnInit {
  skills: Skill[] = [];

  skillList: Skill[] = [
    { value: '1', viewValue: 'C#' },
    { value: '2', viewValue: 'SQL' },
    { value: '3', viewValue: 'Java' },
    { value: '3', viewValue: 'Elastic Search' },
    { value: '3', viewValue: 'Kotlin' },
    { value: '3', viewValue: 'Angular' },
    { value: '3', viewValue: 'React' },
    { value: '3', viewValue: 'Javascript' },
  ];

  selectedSkill: Skill;

  constructor() { }

  ngOnInit() {
  }

  add(skill: Skill): void {
    // name = name.trim();
    if (!skill) { return; }
    if (!this.skills.find(s => s === skill)) {
      this.skills.push(skill);
      this.selectedSkill = undefined;
    }
  }

  delete(name: string): void {

  }

}
