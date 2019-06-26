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
    { value: '3', viewValue: 'Docker' }
  ];

  selectedSkill: Skill;

  onSelect(skill: Skill): void {
    this.selectedSkill = skill;
  }

  constructor() { }

  ngOnInit() {
  }

  add(skill: Skill): void {
    // name = name.trim();
    if (!skill) { return; }
    this.skills.push(skill);
  }

  delete(name: string): void {

  }

}
