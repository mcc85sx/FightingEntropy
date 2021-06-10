using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.JSInterop;

namespace RazorShell.Client
{
    public class Window
    {
        public static readonly IJSRuntime JSR;

        public static event Func<Task> OnResize;

        [JSInvokable]
        public static async Task OnBrowserResize()
        {
            await OnResize?.Invoke();
        }
        public static async Task<int> GetInnerHeight()
        {
            return await JSR.InvokeAsync<int>("browserResize.getInnerHeight");
        }
        public static async Task<int> GetInnerWidth()
        {
            return await JSR.InvokeAsync<int>("browserResize.getInnerWidth");
        }

        public string         ID { get; set; } = null;
        public object      Stage { get; set; } = null;

        public double      width { get; set; } = 0;
        public double     height { get; set; } = 0;
        public double       side { get; set; } = 0;
        public double       main { get; set; } = 0;
        public double      pixel { get; set; } = 0;

        public Window()
        {
            this.Set();
            this.GetID();
            this.GetStage();
        }

        void Set()
        {
            this.width  = JSR.InvokeAsync<int>("browserResize.getInnerWidth").Result;
            this.height = JSR.InvokeAsync<int>("browserResize.getInnerHeight").Result;
            
            this.side   = this.width * 0.15f;
            this.main   = this.width * 0.85f;
            this.pixel  = this.width / 1920;
        }

        public void GetID()
        {
            if (this.width < 720)
            {
                this.ID = "Compact";
            }

            else
            {
                this.ID = "Full";
            }
        }

        public void GetStage()
        {
            this.Stage = new Stage(this,this.ID);
        }
    }
}
