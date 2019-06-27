import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {
  title = 'matching-learning';
  loading: boolean;
  showContent: boolean;

  ngOnInit(): void {
  }



  processData() {
    this.showContent = false;
    this.loading = true;

    setTimeout(() => {
      this.loading = false;
      this.showContent = true;
    }, 3000);
  }
}
