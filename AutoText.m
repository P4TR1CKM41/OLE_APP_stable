function hOut = AutoText(textString,varargin)
l = legend(textString,varargin{:});
t = annotation('textbox');
t.String = textString;
t.Position = l.Position;
delete(l);
t.LineStyle = 'None';
if nargout
    hOut = t;
end