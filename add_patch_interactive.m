function app= add_patch_interactive(app,O, U, UIAX, handle)
            delete(app.(handle));
            ylimits = app.(UIAX).YLim;
            x = [app.(O).Value app.(U).Value app.(U).Value app.(O).Value];
            y = [min(ylimits) min(ylimits) max(ylimits) max(ylimits)];
            app.(handle) = patch(app.(UIAX),x,y,'red', 'FaceAlpha',.2, "Linestyle", "none");
end